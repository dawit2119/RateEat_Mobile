import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';

class VerifyEmailOtpUseCase
    extends UseCase<UserLoginResponse, VerifyEmailOtpParams> {
  final AuthenticationRepository repository;

  VerifyEmailOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, UserLoginResponse>> call(
      VerifyEmailOtpParams params) async {
    return await repository.verifyEmailOtp(
        email: params.email, code: params.code);
  }
}

class VerifyEmailOtpParams extends Equatable {
  final String email;
  final String code;

  const VerifyEmailOtpParams({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}
