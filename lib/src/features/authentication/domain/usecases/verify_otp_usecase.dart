import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';

class VerifyOtpUseCase extends UseCase<UserLoginResponse, VerifyOtpParams> {
  final AuthenticationRepository repository;

  VerifyOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, UserLoginResponse>> call(
      VerifyOtpParams params) async {
    return await repository.verifyOtp(
        phoneNumber: params.phoneNumber, code: params.code);
  }
}

class VerifyOtpParams extends Equatable {
  final String phoneNumber;
  final String code;

  const VerifyOtpParams({
    required this.phoneNumber,
    required this.code,
  });

  @override
  List<Object?> get props => [phoneNumber, code];
}
