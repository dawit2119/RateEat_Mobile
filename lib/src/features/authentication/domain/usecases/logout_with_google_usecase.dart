import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';

class SignOutWithGoogleUseCase extends UseCase<void, NoParams> {
  final AuthenticationRepository repository;

  SignOutWithGoogleUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logoutWithGoogle();
  }
}
