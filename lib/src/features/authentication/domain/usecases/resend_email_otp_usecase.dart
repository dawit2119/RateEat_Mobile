import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../repositories/authentication_repository.dart';

import '../../../../core/core.dart';

class ResendEmailOtpUseCase extends UseCase<void, ResendEmailOtpParams> {
  final AuthenticationRepository repository;

  ResendEmailOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ResendEmailOtpParams params) async {
    return await repository.resendEmailOtp(email: params.email);
  }
}

class ResendEmailOtpParams extends Equatable {
  final String email;

  const ResendEmailOtpParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}
