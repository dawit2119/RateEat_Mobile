import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';

class SendEditEmailOtpUseCase extends UseCase<void, SendEditEmailOtpParams> {
  final AuthenticationRepository repository;

  SendEditEmailOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SendEditEmailOtpParams params) async {
    return await repository.sendEditEmailOtp(email: params.email);
  }
}

class SendEditEmailOtpParams extends Equatable {
  final String email;

  const SendEditEmailOtpParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}
