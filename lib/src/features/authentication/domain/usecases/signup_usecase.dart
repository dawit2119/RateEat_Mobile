import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import '../../../../core/core.dart';
import '../../../user_profile/data/data.dart';
import '../repositories/authentication_repository.dart';

class SignupUseCase extends UseCase<User, SignUpParams> {
  final AuthenticationRepository repository;

  SignupUseCase({required this.repository});

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(userData: params.user);
  }
}

class SignUpParams extends Equatable {
  final UserModel user;

  const SignUpParams({required this.user});

  @override
  List<Object?> get props => [user];
}
