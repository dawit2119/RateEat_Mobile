import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import './incentive.dart';
import 'entity.dart';

part 'user.g.dart';

@HiveType(typeId: 14)
class User extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? telegramId;
  @HiveField(2)
  final String? facebookId;
  @HiveField(3)
  final String? userName;
  @HiveField(4)
  final String? firstName;
  @HiveField(5)
  final String? lastName;
  @HiveField(6)
  final String? dateOfBirth;
  @HiveField(7)
  final String? email;
  @HiveField(8)
  final String? gender;
  @HiveField(9)
  final String? roleId;
  @HiveField(10)
  final String? phoneNumber;
  @HiveField(11)
  final String? image;
  @HiveField(12)
  final DateTime? createdAt;
  @HiveField(13)
  final DateTime? updatedAt;
  @HiveField(14)
  final String? token;
  @HiveField(15)
  final Incentive? incentive;
  @HiveField(16)
  final String? fcmToken;
  @HiveField(17)
  final int? verified;
  @HiveField(18)
  final UserLevel? levelInfo;
  @HiveField(19)
  final UserStat? userStat;
  @HiveField(20)
  final bool? isFollowed;
  @HiveField(21)
  final String? refreshToken;

  const User({
    required this.id,
    required this.telegramId,
    required this.facebookId,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
    required this.gender,
    required this.roleId,
    required this.phoneNumber,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
    required this.incentive,
    required this.fcmToken,
    required this.verified,
    required this.levelInfo,
    required this.userStat,
    required this.isFollowed,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [
        id,
        telegramId,
        facebookId,
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
        incentive,
        fcmToken,
        verified,
        levelInfo,
        userStat,
        refreshToken
      ];
}
