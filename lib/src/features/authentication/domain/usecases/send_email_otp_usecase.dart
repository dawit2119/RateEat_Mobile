import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';

class SendEmailOtpUseCase extends UseCase<void, SendEmailOtpParams> {
  final AuthenticationRepository repository;

  SendEmailOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SendEmailOtpParams params) async {
    return await repository.sendEmailOtp(email: params.email);
  }
}

class SendEmailOtpParams extends Equatable {
  final String email;

  const SendEmailOtpParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}
