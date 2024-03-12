import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/incentive.dart';

import '../../features/user_profile/domain/entity/user.dart';

part 'local_user_model.g.dart';

@HiveType(typeId: 2)
class LocalUserModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? telegramId;

  @HiveField(2)
  String? facebookId;

  @HiveField(3)
  String? userName;

  @HiveField(4)
  String? firstName;

  @HiveField(5)
  String? lastName;

  @HiveField(6)
  String? dateOfBirth;

  @HiveField(7)
  String? email;

  @HiveField(8)
  String? gender;

  @HiveField(9)
  String? roleId;

  @HiveField(10)
  String? phoneNumber;

  @HiveField(11)
  String? image;

  @HiveField(12)
  DateTime? createdAt;

  @HiveField(13)
  DateTime? updatedAt;

  @HiveField(14)
  String? token;

  @HiveField(15)
  Incentive? incentive;

  @HiveField(16)
  String? fcmToken;

  @HiveField(17)
  int? verified;

  @HiveField(18)
  String? refreshtoken;

  LocalUserModel({
    this.id,
    this.telegramId,
    this.facebookId,
    this.userName,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.email,
    this.gender,
    this.roleId,
    this.phoneNumber,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.refreshtoken,
    this.incentive,
    this.fcmToken,
    this.verified,
  });

  factory LocalUserModel.fromUserModel(User user) {
    return LocalUserModel(
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
  }

  LocalUserModel copyWith(
      {String? id,
      String? telegramId,
      String? facebookId,
      String? userName,
      String? firstName,
      String? lastName,
      String? dateOfBirth,
      String? email,
      String? gender,
      String? roleId,
      String? phoneNumber,
      String? image,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? token,
      String? refreshtoken,
      Incentive? incentive,
      String? fcmToken,
      int? verified}) {
    return LocalUserModel(
        id: id ?? this.id,
        telegramId: telegramId ?? this.telegramId,
        facebookId: facebookId ?? this.facebookId,
        userName: userName ?? this.userName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        email: email ?? this.email,
        gender: gender ?? this.gender,
        roleId: roleId ?? this.roleId,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        image: image ?? this.image,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        token: token ?? this.token,
        refreshtoken: refreshtoken ?? this.refreshtoken,
        incentive: incentive ?? this.incentive,
        fcmToken: fcmToken ?? this.fcmToken,
        verified: verified ?? this.verified);
  }
}
