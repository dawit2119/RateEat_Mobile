import 'package:rateeat_mobile/src/features/user_profile/data/models/user_level_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/user_stat_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

import '../../domain/entity/incentive.dart';
import './incentive_model.dart';

class UserModel extends User {
  const UserModel(
      {super.id,
      super.telegramId,
      super.facebookId,
      super.userName,
      super.firstName,
      super.lastName,
      super.dateOfBirth,
      super.email,
      super.gender,
      super.roleId,
      super.phoneNumber,
      super.image,
      super.createdAt,
      super.updatedAt,
      super.token,
      super.incentive,
      super.fcmToken,
      super.verified,
      super.levelInfo,
      super.userStat,
      super.isFollowed,
      super.refreshToken});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var data = json['user'];
    return UserModel(
      id: data['id'] as String? ?? "",
      telegramId: data['telegram_id'] as String? ?? "",
      facebookId: data['facebook_id'] as String? ?? "",
      userName: data['username'] as String? ?? "",
      firstName: data['first_name'] as String? ?? "",
      lastName: data['last_name'] as String? ?? "",
      dateOfBirth: data['date_of_birth'] as String? ?? "",
      email: data['email'] as String? ?? "",
      gender: data['gender'] as String? ?? "",
      roleId: data['role_id'] as String?,
      phoneNumber: data['phone_number'] as String? ?? "",
      image: data['image'] as String? ?? "",
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'] as String)
          : DateTime.timestamp(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : DateTime.fromMicrosecondsSinceEpoch(0),
      token: data['token'] as String? ?? '',
      refreshToken: data['refreshtoken'] as String? ?? "",
      incentive: json['incentive'] != null
          ? IncentiveModel.fromMap(json['incentive'])
          : null,
      verified: data['verified'] as int? ?? 0,
      levelInfo: json['level_information'] != null
          ? UserLevelModel.fromMap(json['level_information'])
          : null,
      userStat:
          json['stats'] != null ? UserStatModel.fromMap(json['stats']) : null,
      isFollowed: json['is_following'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'telegram_id': telegramId,
        'facebook_id': facebookId,
        'user_name': userName,
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': dateOfBirth,
        'email': email,
        'gender': gender,
        'role_id': roleId,
        'phone_number': phoneNumber,
        'image': image,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'token': token,
        'refreshtoken': refreshToken,
        'fcm_token': fcmToken,
        'is_followed': isFollowed,
      };

  UserModel copyWith(
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
      String? refreshToken,
      Incentive? incentive,
      String? fcmToken,
      int? verified,
      UserLevel? levelInfo,
      UserStat? userStat}) {
    return UserModel(
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
        refreshToken: refreshToken ?? this.refreshToken,
        incentive: incentive ?? this.incentive,
        fcmToken: fcmToken ?? this.fcmToken,
        verified: verified ?? this.verified,
        levelInfo: levelInfo ?? this.levelInfo,
        userStat: userStat ?? this.userStat);
  }

  @override
  List<Object?> get props {
    return [
      id,
      telegramId,
      facebookId,
      userName,
      firstName,
      lastName,
      dateOfBirth,
      email,
      gender,
      roleId,
      phoneNumber,
      image,
      createdAt,
      updatedAt,
      token,
      refreshToken,
      incentive,
      fcmToken,
      verified
    ];
  }
}
