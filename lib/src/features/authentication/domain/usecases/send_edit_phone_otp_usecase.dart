import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';

class SendEditPhoneOtpUseCase extends UseCase<void, SendEditPhoneOtpParams> {
  final AuthenticationRepository repository;

  SendEditPhoneOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SendEditPhoneOtpParams params) async {
    return await repository.sendEditPhoneOtp(phoneNumber: params.phoneNumber);
  }
}

class SendEditPhoneOtpParams extends Equatable {
  final String phoneNumber;

  const SendEditPhoneOtpParams({
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [phoneNumber];
}
