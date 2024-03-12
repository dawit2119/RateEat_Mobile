import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';

class LoginGoogleUseCase extends UseCase<UserLoginResponse, LoginEmailParams> {
  final AuthenticationRepository repository;

  LoginGoogleUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, UserLoginResponse>> call(
      LoginEmailParams params) async {
    return await repository.loginGoogle(
      email: params.email!,
      accessToken: params.accessToken,
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}
