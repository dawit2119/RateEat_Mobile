import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

class UserLoginResponseModel extends UserLoginResponse {
  UserLoginResponseModel({
    required super.user,
    required super.statusCode,
  });

  factory UserLoginResponseModel.fromJson(dynamic response) =>
      UserLoginResponseModel(
        user: UserModel.fromJson(response.data),
        statusCode: response.statusCode,
      );

  UserLoginResponse toEntity() => UserLoginResponse(
        user: user,
        statusCode: statusCode,
      );
}
