import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';

import '../../../user_profile/user_profile.dart';

abstract class AuthenticationLocalSource {
  LocalUserModel? getUserCredential();
  Future<void> cacheUserCredential({
    required UserModel user,
  });
  Future<void> updateUserCredential({
    required LocalUserModel updatedUserInformation,
  });
  Future<void> clearUserCredential();
  Future<void> initializeApp();
  Future<bool> getAppInitialization();
}

class AuthenticationLocalSourceImpl extends AuthenticationLocalSource {
  final userBox = Hive.box<LocalUserModel>("userBox");
  AuthenticationLocalSourceImpl();

  @override
  Future<void> cacheUserCredential({required UserModel user}) async {
    final userData = LocalUserModel(
      id: user.id,
      telegramId: user.telegramId,
      facebookId: user.facebookId,
      userName: user.userName,
      firstName: user.firstName,
      lastName: user.lastName,
      dateOfBirth: user.dateOfBirth,
      email: user.email,
      gender: user.gender,
      roleId: user.roleId,
      phoneNumber: user.phoneNumber,
      image: user.image,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      token: user.token,
      refreshtoken: user.refreshToken,
      incentive: user.incentive,
      fcmToken: user.fcmToken,
      verified: user.verified,
    );
    return userBox.put("user", userData);
  }

  @override
  Future<void> clearUserCredential() {
    return userBox.delete("user");
  }

  @override
  Future<bool> getAppInitialization() {
    throw UnimplementedError();
  }

  @override
  LocalUserModel? getUserCredential() {
    final user = userBox.get("user");
    final Map<String, dynamic> data;
    if (user != null) {
      try {
        data = parseJwt(user.token!);
        final expireDate =
            DateTime.fromMillisecondsSinceEpoch(data["exp"] * 1000);
        if (DateTime.now().compareTo(expireDate) >= 0) {
          final refreshTokenData = parseJwt(user.refreshtoken!);
          final refreshTokenExpireDate = DateTime.fromMillisecondsSinceEpoch(
              refreshTokenData["exp"] * 1000);

          if (DateTime.now().compareTo(refreshTokenExpireDate) >= 0) {
            try {
              clearUserCredential();
            } catch (e) {
              debugPrint(e.toString());
            }
            return null;
          } else {
            return user;
          }
        }
      } catch (e) {
        developer.log("error while decoding jwt token");
        developer.log(e.toString());
      }
    }
    return user;
  }

  @override
  Future<void> initializeApp() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserCredential(
      {required LocalUserModel updatedUserInformation}) {
    final user = userBox.get("user");
    if (user != null) {
      return userBox.put(
        "user",
        user.copyWith(
          userName: updatedUserInformation.userName,
          firstName: updatedUserInformation.firstName,
          lastName: updatedUserInformation.lastName,
          email: updatedUserInformation.email,
          phoneNumber: updatedUserInformation.phoneNumber,
          gender: updatedUserInformation.gender,
          dateOfBirth: updatedUserInformation.dateOfBirth,
          image: updatedUserInformation.image,
          token: updatedUserInformation.token,
          refreshtoken: updatedUserInformation.refreshtoken,
          incentive: user.incentive,
          verified: user.verified,
        ),
      );
    } else {
      throw CacheFailure();
    }
  }
}

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}
