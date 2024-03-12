import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';

class LoginFacebookUseCase
    extends UseCase<UserLoginResponse, LoginEmailParams> {
  final AuthenticationRepository repository;

  LoginFacebookUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, UserLoginResponse>> call(
      LoginEmailParams params) async {
    return await repository.loginFacebook(accessToken: params.accessToken);
  }
}

class LoginEmailParams extends Equatable {
  final String? email;
  final String firstName;
  final String? lastName;
  final String accessToken;

  const LoginEmailParams({
    this.email,
    required this.accessToken,
    required this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [email, accessToken, firstName, lastName];
}
