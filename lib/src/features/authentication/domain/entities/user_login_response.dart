import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

class UserLoginResponse {
  final UserModel user;
  final int statusCode;

  UserLoginResponse({
    required this.user,
    required this.statusCode,
  });

  UserLoginResponse copyWith({
    UserModel? user,
    int? statusCode,
  }) {
    return UserLoginResponse(
      user: user ?? this.user,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
