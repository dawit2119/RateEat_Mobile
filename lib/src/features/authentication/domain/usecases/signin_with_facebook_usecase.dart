import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import '../../../../core/core.dart';

class SignInWithFacebookUseCase extends UseCase<User, NoParams> {
  final AuthenticationRepository repository;

  SignInWithFacebookUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, User>> call(params) async {
    return await repository.signInWithFacebook();
  }
}
