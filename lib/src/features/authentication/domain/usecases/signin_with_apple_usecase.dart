import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/repositories/authentication_repository.dart';

class SignInWithAppleUsecase extends UseCase<UserLoginResponse, NoParams> {
  final AuthenticationRepository repository;

  SignInWithAppleUsecase({required this.repository});

  @override
  Future<Either<Failure, UserLoginResponse>> call(NoParams params) async {
    return await repository.signInWithApple();
  }
}