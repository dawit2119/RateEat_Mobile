import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import '../../../user_profile/data/data.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, Unit>> sendEmailOtp({
    required String email,
  });
  Future<Either<Failure, UserLoginResponse>> verifyEmailOtp({
    required String email,
    required String code,
  });
  Future<Either<Failure, Unit>> resendEmailOtp({
    required String email,
  });
  Future<Either<Failure, Unit>> sendPhoneOtp({
    required String phoneNumber,
  });
  Future<Either<Failure, Unit>> sendEditPhoneOtp({
    required String phoneNumber,
  });
  Future<Either<Failure, Unit>> sendEditEmailOtp({
    required String email,
  });
  Future<Either<Failure, UserLoginResponse>> verifyOtp({
    required String phoneNumber,
    required String code,
  });

  Future<Either<Failure, Unit>> resendOtp({
    required String phoneNumber,
  });

  Future<Either<Failure, User>> signUp({required UserModel userData});
  Future<Either<Failure, UserLoginResponse>> loginGoogle({
    required String email,
    required String accessToken,
    required String firstName,
    String? lastName,
  });
  Future<Either<Failure, UserLoginResponse>> loginFacebook(
      {required String accessToken});
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, Unit>> logoutWithGoogle();
  Future<Either<Failure, User>> signInWithFacebook();
  Future<Either<Failure, Unit>> logoutWithFacebook();
  Future<Either<Failure, UserLoginResponse>> signInWithApple();
  Future<Either<Failure, Unit>> signOutWithApple();
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, Unit>> deleteAccount();
  Future<Either<Failure, User>> refreshToken({required String refreshToken});
}
