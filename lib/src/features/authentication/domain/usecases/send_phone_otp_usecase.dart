import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';

class SendPhoneOtpUseCase extends UseCase<void, SendPhoneOtpParams> {
  final AuthenticationRepository repository;

  SendPhoneOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SendPhoneOtpParams params) async {
    return await repository.sendPhoneOtp(phoneNumber: params.phoneNumber);
  }
}

class SendPhoneOtpParams extends Equatable {
  final String phoneNumber;

  const SendPhoneOtpParams({
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [phoneNumber];
}
