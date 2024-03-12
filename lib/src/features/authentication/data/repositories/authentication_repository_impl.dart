import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/session_track.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/core/service/firebase_crachlytics.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:rateeat_mobile/src/features/authentication/data/data.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/domain.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

import '../../../background_processing/data/background_processing_api.dart';
import '../datasources/authentication_with_apple.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final RemoteAuthenticationSource remoteSource;
  final AuthenticationLocalSource localSource;
  final AnalyticsObserver observer;
  final FirebaseCrashLogger log;

  AuthenticationRepositoryImpl({
    required this.remoteSource,
    required this.observer,
    required this.log,
    required this.localSource,
  });

  @override
  Future<Either<Failure, Unit>> sendPhoneOtp(
      {required String phoneNumber}) async {
    try {
      await remoteSource.sendPhoneOtp(
        phoneNumber: phoneNumber,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendEmailOtp({required String email}) async {
    try {
      await remoteSource.sendEmailOtp(
        email: email,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendEditPhoneOtp(
      {required String phoneNumber}) async {
    try {
      await remoteSource.sendEditPhoneOtp(
        phoneNumber: phoneNumber,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendEditEmailOtp(
      {required String email}) async {
    try {
      await remoteSource.sendEditEmailOtp(
        email: email,
      );
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLoginResponse>> verifyOtp(
      {required String phoneNumber, required String code}) async {
    try {
      final response =
          await remoteSource.verifyOtp(phoneNumber: phoneNumber, code: code);
      //* Save to analytics
      await observer.logLogin(method: "Phone", params: {
        "phone": response.user.phoneNumber ?? phoneNumber,
        "username": response.user.userName,
        "firstName": response.user.firstName,
        "lastName": response.user.lastName,
        "image": response.user.image,
      });

      //* Save in the analytics
      await observer.setUserId(userId: response.user.id!);
      await log.setUserIdentifier(userId: response.user.id!);

      //* Save to local storage
      await localSource.cacheUserCredential(
        user: response.user,
      );

      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    } on UnauthorizedRequestException {
      return Left(UnauthorizedRequestFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserLoginResponse>> verifyEmailOtp(
      {required String email, required String code}) async {
    try {
      final response =
          await remoteSource.verifyEmailOtp(email: email, code: code);
      //* Save to analytics
      await observer.logLogin(method: "email", params: {
        "email": response.user.email ?? email,
        "username": response.user.userName,
        "firstName": response.user.firstName,
        "lastName": response.user.lastName,
        "image": response.user.image,
      });

      //* Save in the analytics
      await observer.setUserId(userId: response.user.id!);
      await log.setUserIdentifier(userId: response.user.id!);

      //* Save to local storage
      await localSource.cacheUserCredential(
        user: response.user,
      );

      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    } on UnauthorizedRequestException {
      return Left(UnauthorizedRequestFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resendOtp({
    required String phoneNumber,
  }) async {
    try {
      await remoteSource.resendOtp(phoneNumber: phoneNumber);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resendEmailOtp({
    required String email,
  }) async {
    try {
      await remoteSource.resendEmailOtp(email: email);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp({required UserModel userData}) async {
    try {
      final user = await remoteSource.signUp(
        user: userData,
      );
      //* Save to analytics
      await observer.logSignUp(method: "phone_or_email", params: {
        "email": user.email!,
        "username": user.userName,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "image": user.image,
      });

      //* Save in the analytics
      await observer.setUserId(userId: user.id!);
      await log.setUserIdentifier(userId: user.id!);
      //* Save to local storage
      await localSource.cacheUserCredential(
        user: user,
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserLoginResponse>> loginFacebook(
      {required String accessToken}) async {
    try {
      final response = await remoteSource.loginFacebook(
        accessToken: accessToken,
      );
      //* Save in the analytics
      await observer.setUserId(userId: response.user.id!);
      await log.setUserIdentifier(userId: response.user.id!);
      //* Save to local storage
      await localSource.cacheUserCredential(
        user: response.user,
      );
      return Right(response);
    } on UnauthorizedRequestException {
      return Left(UnauthorizedRequestFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserLoginResponse>> loginGoogle(
      {required String email,
      required String accessToken,
      required String firstName,
      String? lastName}) async {
    try {
      final response = await remoteSource.loginGoogle(
        email: email,
        firstName: firstName,
        lastName: lastName,
        accessToken: accessToken,
      );
      //* Save in the analytics
      await observer.setUserId(userId: response.user.id!);
      await log.setUserIdentifier(userId: response.user.id!);
      //* Save to local storage
      await localSource.cacheUserCredential(
        user: response.user,
      );
      return Right(response);
    } on UnauthorizedRequestException {
      return Left(UnauthorizedRequestFailure());
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final user = await AuthenticationWithGoogle.signInWithGoogle();

      // //*  Save to analytics
      await observer.logLogin(method: "Google", params: {
        "email": user.email,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "image": user.image,
      });

      return Right(user);
    } catch (exception) {
      if (exception is SignInWithGoogleException) {
        return Left(
          SignInWithGoogleFailure(
            errorMessage: exception.errorMessage,
          ),
        );
      } else if (exception is DefaultException) {
        return Left(
          AnonymousFailure(),
        );
      }
      return Left(SignInWithGoogleFailure(errorMessage: 'Unknown Failure'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logoutWithGoogle() async {
    try {
      await AuthenticationWithGoogle.signOut();
      await localSource.clearUserCredential();
      return const Right(unit);
    } catch (exception) {
      if (exception is SignOutWithGoogleException) {
        return Left(handleGoogleSignOutException(exception));
      }
      return Left(SignOutWithGoogleFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithFacebook() async {
    try {
      final user = await AuthenticationWithFacebook.signInWithFacebook();
      //*  Save to analytics
      await observer.logLogin(method: "Facebook", params: {
        "email": user.email,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "image": user.image,
      });
      return Right(user);
    } catch (exception) {
      if (exception is SignInWithFacebookException) {
        return Left(
          SignInWithFacebookFailure(
            errorMessage: exception.errorMessage,
          ),
        );
      }
      return Left(SignInWithFacebookFailure(errorMessage: 'Unknown Failure'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logoutWithFacebook() async {
    try {
      await AuthenticationWithFacebook.signOut();
      await localSource.clearUserCredential();
      return const Right(unit);
    } catch (exception) {
      if (exception is SignOutWithFacebookException) {
        return Left(handleFacebookSignOutException(exception));
      }
      return Left(SignOutWithFacebookFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await localSource.clearUserCredential();
      await remoteSource.logout();
      await sendSessionData();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          errorMessage: e.errorMessage.toString(),
        ),
      );
    } catch (e) {
      return const Right(unit);
    }
  }

  @override
  Future<Either<Failure, UserLoginResponse>> signInWithApple() async {
    try {
      final user = await AuthenticationWithApple.signInWithApple();
      
      final response = await remoteSource.loginApple(
        email: user.email!,
        firstName: user.firstName!,
        lastName: user.lastName,
        identityToken: user.token!,
      );
      
      //* Save to analytics
      await observer.logLogin(method: "Apple", params: {
        "email": user.email,
        "firstName": user.firstName,
        "lastName": user.lastName,
      });
      
      //* Save in the analytics
      await observer.setUserId(userId: response.user.id!);
      await log.setUserIdentifier(userId: response.user.id!);
      
      //* Save to local storage
      await localSource.cacheUserCredential(
        user: response.user,
      );
      
      return Right(response);
    } catch (exception) {
      if (exception is SignInWithAppleException) {
        return Left(
          SignInWithAppleFailure(
            errorMessage: exception.errorMessage,
          ),
        );
      }
      return Left(SignInWithAppleFailure(errorMessage: 'Unknown Failure'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOutWithApple() async {
    try {
      await AuthenticationWithApple.signOut();
      await localSource.clearUserCredential();
      return const Right(unit);
    } catch (exception) {
      return Left(SignOutWithAppleFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await remoteSource.deleteAccount();
      await sendSessionData();
      await localSource.clearUserCredential();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          errorMessage: e.errorMessage.toString(),
        ),
      );
    } catch (e) {
      return const Right(unit);
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken(
      {required String refreshToken}) async {
    try {
      final loginResponse = await remoteSource.refreshToken(refreshToken);
      return Right(loginResponse.user);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}

//* Session Management
Future<void> sendSessionData() async {
  try {
    final userManagement = dpLocator<LocalAnalyticsObserver>();
    final userSessionBox = await Hive.openBox<UserSession>('user_sessions');
    final session = userSessionBox.get('session');
    if (session != null) {
      final currentTime = DateTime.now();
      final prevTotalTime = session.totalSessionTime;
      final diff = (currentTime.difference(session.startTime)).inSeconds;
      session.totalSessionTime = prevTotalTime + diff;
      session.startTime = DateTime.now();
      session.endTime = DateTime.now();
      await userSessionBox.put('session', session);
      //* send Data
      await sendAnalyticsData();
      await userManagement.clearSessionAnalyticsData();
    } else {
      await startSession();
    }
  } catch (e) {
    throw CacheException();
  }
}
