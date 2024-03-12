import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/repositories/authentication_repository.dart';

class LogoutWithAppleUsecase extends UseCase<void, NoParams> {
  final AuthenticationRepository repository;

  LogoutWithAppleUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOutWithApple();
  }
}