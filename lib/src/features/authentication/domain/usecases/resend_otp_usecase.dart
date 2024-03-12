import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../repositories/authentication_repository.dart';

import '../../../../core/core.dart';

class ResendOtpUseCase extends UseCase<void, ResendOtpParams> {
  final AuthenticationRepository repository;

  ResendOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ResendOtpParams params) async {
    return await repository.resendOtp(phoneNumber: params.phoneNumber);
  }
}

class ResendOtpParams extends Equatable {
  final String phoneNumber;

  const ResendOtpParams({
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [phoneNumber];
}
