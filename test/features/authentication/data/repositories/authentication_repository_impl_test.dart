import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/core/service/firebase_crachlytics.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/authentication/data/models/user_login_response_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

import 'authentication_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<RemoteAuthenticationSource>(),
  MockSpec<AnalyticsObserver>(),
  MockSpec<FirebaseCrashLogger>(),
])
void main() {
  late AuthenticationRepositoryImpl authenticationRepositoryImpl;
  late MockRemoteAuthenticationSource mockRemoteAuthenticationSource;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;

  setUp(() {
    mockRemoteAuthenticationSource = MockRemoteAuthenticationSource();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    authenticationRepositoryImpl = AuthenticationRepositoryImpl(
      remoteSource: mockRemoteAuthenticationSource,
      localSource: mockAuthenticationLocalSource,
      observer: MockAnalyticsObserver(),
      log: MockFirebaseCrashLogger(),
    );
  });

  const phoneNumber = '123456789';
  const email = 'test@example.com';
  const code = '2342';
  final testResponseModel = UserLoginResponseModel(
    user: UserModel(
      id: "1",
      telegramId: "1",
      facebookId: "1",
      userName: "John",
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '2013-04-20 12:00:00',
      email: 'doe@example',
    ),
    statusCode: 200,
  );

  group('login with google', () {
    test(
        'should return a User from his gmail account when the call to the remote data source is successful',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.loginGoogle(
        email: testResponseModel.user.email!,
        firstName: testResponseModel.user.firstName!,
        lastName: testResponseModel.user.lastName,
        accessToken: 'accessToken',
      )).thenAnswer(
        (_) async => testResponseModel,
      );
      // act
      final result = await authenticationRepositoryImpl.loginGoogle(
        email: testResponseModel.user.email!,
        firstName: testResponseModel.user.firstName!,
        lastName: testResponseModel.user.lastName,
        accessToken: 'accessToken',
      );
      // assert
      expect(result, equals(Right(testResponseModel)));
    });

    test(
        'should return  a unauthorized failure when the call to the remote data source is 404',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.loginGoogle(
        email: testResponseModel.user.email!,
        firstName: testResponseModel.user.firstName!,
        lastName: testResponseModel.user.lastName,
        accessToken: 'accessToken',
      )).thenThrow(
        UnauthorizedRequestException(),
      );
      // act
      final result = await authenticationRepositoryImpl.loginGoogle(
        email: testResponseModel.user.email!,
        firstName: testResponseModel.user.firstName!,
        lastName: testResponseModel.user.lastName,
        accessToken: 'accessToken',
      );
      // assert
      expect(result, equals(Left(UnauthorizedRequestFailure())));
    });

    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.loginGoogle(
        email: testResponseModel.user.email!,
        firstName: testResponseModel.user.firstName!,
        lastName: testResponseModel.user.lastName,
        accessToken: 'accessToken',
      )).thenThrow(
        ServerException(),
      );
      // act
      final result = await authenticationRepositoryImpl.loginGoogle(
        email: testResponseModel.user.email!,
        firstName: testResponseModel.user.firstName!,
        lastName: testResponseModel.user.lastName,
        accessToken: 'accessToken',
      );
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });

    // test('should return a Connection failure when there is no connection',
    //     () async {
    //   // arrange
    //   when(mockRemoteAuthenticationSource.loginGoogle(
    //     email: testResponseModel.user.email!,
    //     firstName: testResponseModel.user.firstName!,
    //     lastName: testResponseModel.user.lastName,
    //     accessToken: 'accessToken',
    //   )).thenThrow(
    //     const SocketException('failed to connect to the server'),
    //   );
    //   // act
    //   final result = await authenticationRepositoryImpl.loginGoogle(
    //     email: testResponseModel.user.email!,
    //     firstName: testResponseModel.user.firstName!,
    //     lastName: testResponseModel.user.lastName,
    //     accessToken: 'accessToken',
    //   );
    //   // assert
    //   expect(result,
    //       equals(Left(NetworkFailure(errorMessage: "No internet connection"))));
    // });

    test(
        'should return a Cache failure when the call to the local data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.loginGoogle(
        email: testResponseModel.user.email!,
        firstName: testResponseModel.user.firstName!,
        lastName: testResponseModel.user.lastName,
        accessToken: 'accessToken',
      )).thenThrow(
        CacheException(),
      );
      // act
      final result = await authenticationRepositoryImpl.loginGoogle(
        email: testResponseModel.user.email!,
        firstName: testResponseModel.user.firstName!,
        lastName: testResponseModel.user.lastName,
        accessToken: 'accessToken',
      );
      // assert
      expect(result, equals(Left(CacheFailure(errorMessage: "Cache failure"))));
    });
  });

  group('login with facebook', () {
    test(
        'should return a User from his facebook account when the call to the remote data source is successful',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.loginFacebook(
        accessToken: 'accessToken',
      )).thenAnswer(
        (_) async => testResponseModel,
      );
      // act
      final result = await authenticationRepositoryImpl.loginFacebook(
        accessToken: 'accessToken',
      );
      // assert
      expect(result, equals(Right(testResponseModel)));
    });

    test(
        'should return  a unauthorized failure when the call to the remote data source is 404',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.loginFacebook(
        accessToken: 'accessToken',
      )).thenThrow(
        UnauthorizedRequestException(),
      );
      // act
      final result = await authenticationRepositoryImpl.loginFacebook(
        accessToken: 'accessToken',
      );
      // assert
      expect(result, equals(Left(UnauthorizedRequestFailure())));
    });

    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.loginFacebook(
        accessToken: 'accessToken',
      )).thenThrow(
        ServerException(),
      );
      // act
      final result = await authenticationRepositoryImpl.loginFacebook(
        accessToken: 'accessToken',
      );
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });

    // test('should return a Connection failure when there is no connection',
    //     () async {
    //   // arrange
    //   when(mockRemoteAuthenticationSource.loginFacebook(
    //     accessToken: 'accessToken',
    //   )).thenThrow(
    //     const SocketException('failed to connect to the server'),
    //   );
    //   // act
    //   final result = await authenticationRepositoryImpl.loginFacebook(
    //     accessToken: 'accessToken',
    //   );
    //   // assert
    //   expect(result,
    //       equals(Left(NetworkFailure(errorMessage: "No internet connection"))));
    // });

    test(
        'should return a Cache failure when the call to the local data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.loginFacebook(
        accessToken: 'accessToken',
      )).thenThrow(
        CacheException(),
      );
      // act
      final result = await authenticationRepositoryImpl.loginFacebook(
        accessToken: 'accessToken',
      );
      // assert
      expect(result, equals(Left(CacheFailure(errorMessage: "Cache failure"))));
    });
  });

  group('sign up', () {
    test(
        'should return a User when the call to the remote data source is successful',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.signUp(
        user: testResponseModel.user,
      )).thenAnswer(
        (_) async => testResponseModel.user,
      );
      // act
      final result = await authenticationRepositoryImpl.signUp(
        userData: testResponseModel.user,
      );
      // assert
      expect(result, equals(Right(testResponseModel.user)));
    });

    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.signUp(
        user: testResponseModel.user,
      )).thenThrow(
        ServerException(),
      );
      // act
      final result = await authenticationRepositoryImpl.signUp(
        userData: testResponseModel.user,
      );
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });

    test(
        'should return a Cache failure when the call to the local data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.signUp(
        user: testResponseModel.user,
      )).thenThrow(
        CacheException(),
      );
      // act
      final result = await authenticationRepositoryImpl.signUp(
        userData: testResponseModel.user,
      );
      // assert
      expect(result, equals(Left(CacheFailure(errorMessage: "Cache failure"))));
    });
  });

  group('send otp to phone', () {
    test('should send otp to phone', () async {
      // arrange
      when(mockRemoteAuthenticationSource.sendPhoneOtp(
        phoneNumber: phoneNumber,
      )).thenAnswer(
        (_) async => unit,
      );
      // act
      final result = await authenticationRepositoryImpl.sendPhoneOtp(
        phoneNumber: phoneNumber,
      );
      // assert
      expect(result, equals(const Right(unit)));
    });
    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.sendPhoneOtp(
        phoneNumber: phoneNumber,
      )).thenThrow(
        ServerException(),
      );
      // act
      final result = await authenticationRepositoryImpl.sendPhoneOtp(
        phoneNumber: phoneNumber,
      );
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });
  });

  group('send otp to phone when editing profile', () {
    test('should send otp to phone when editing profile phone field', () async {
      // arrange
      when(mockRemoteAuthenticationSource.sendEditPhoneOtp(
        phoneNumber: phoneNumber,
      )).thenAnswer(
        (_) async => unit,
      );
      // act
      final result = await authenticationRepositoryImpl.sendEditPhoneOtp(
        phoneNumber: phoneNumber,
      );
      // assert
      expect(result, equals(const Right(unit)));
    });
    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.sendEditPhoneOtp(
        phoneNumber: phoneNumber,
      )).thenThrow(
        ServerException(),
      );
      // act
      final result = await authenticationRepositoryImpl.sendEditPhoneOtp(
        phoneNumber: phoneNumber,
      );
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });
  });

  group('send otp to Email when editing profile', () {
    test('should send otp to email when editing profile email field', () async {
      // arrange
      when(mockRemoteAuthenticationSource.sendEditEmailOtp(
        email: email,
      )).thenAnswer(
        (_) async => unit,
      );
      // act
      final result = await authenticationRepositoryImpl.sendEditEmailOtp(
        email: email,
      );
      // assert
      expect(result, equals(const Right(unit)));
    });
    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.sendEditEmailOtp(
        email: email,
      )).thenThrow(
        ServerException(),
      );
      // act
      final result = await authenticationRepositoryImpl.sendEditEmailOtp(
        email: email,
      );
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });
  });

  group('Verify Phone number and login', () {
    test(
        'should return a User from his phone number when the call to the remote data source is successful',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      )).thenAnswer(
        (_) async => testResponseModel,
      );
      // act
      final result = await authenticationRepositoryImpl.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      );
      // assert
      expect(result, equals(Right(testResponseModel)));
    });

    test(
        'should return  a unauthorized failure when the call to the remote data source is 400',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      )).thenThrow(
        UnauthorizedRequestException(),
      );
      // act
      final result = await authenticationRepositoryImpl.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      );
      // assert
      expect(result, equals(Left(UnauthorizedRequestFailure())));
    });

    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      )).thenThrow(
        ServerException(),
      );
      // act
      final result = await authenticationRepositoryImpl.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      );
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });

    test('should return a Connection failure when there is no connection',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      )).thenThrow(
        SocketException('failed to connect to the server'),
      );
      // act
      final result = await authenticationRepositoryImpl.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      );
      // assert
      expect(result,
          equals(Left(NetworkFailure(errorMessage: "No internet connection"))));
    });

    test(
        'should return a Cache failure when the call to the local data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      )).thenThrow(
        CacheException(),
      );
      // act
      final result = await authenticationRepositoryImpl.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
      );
      // assert
      expect(result, equals(Left(CacheFailure(errorMessage: "Cache failure"))));
    });
  });

  group('resend otp to phone', () {
    test('should resend otp to phone when resend is clicked', () async {
      // arrange
      when(mockRemoteAuthenticationSource.resendOtp(
        phoneNumber: phoneNumber,
      )).thenAnswer(
        (_) async => unit,
      );
      // act
      final result = await authenticationRepositoryImpl.resendOtp(
        phoneNumber: phoneNumber,
      );
      // assert
      expect(result, equals(const Right(unit)));
    });
    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.resendOtp(
        phoneNumber: phoneNumber,
      )).thenThrow(
        ServerException(),
      );
      // act
      final result = await authenticationRepositoryImpl.resendOtp(
        phoneNumber: phoneNumber,
      );
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });
  });

  group('logout', () {
    test('should logout', () async {
      // arrange
      when(mockRemoteAuthenticationSource.logout()).thenAnswer(
        (_) async => unit,
      );
      // act
      final result = await authenticationRepositoryImpl.logout();
      // assert
      expect(result, equals(const Right(unit)));
    });
    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.logout()).thenThrow(
        ServerException(),
      );
      // act
      final result = await authenticationRepositoryImpl.logout();
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });
  });

  group('delete account', () {
    test('should delete account', () async {
      // arrange
      when(mockRemoteAuthenticationSource.deleteAccount()).thenAnswer(
        (_) async => unit,
      );
      // act
      final result = await authenticationRepositoryImpl.deleteAccount();
      // assert
      expect(result, equals(const Right(unit)));
    });
    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      when(mockRemoteAuthenticationSource.deleteAccount()).thenThrow(
        ServerException(errorMessage: "Server failure"),
      );
      // act
      final result = await authenticationRepositoryImpl.deleteAccount();
      // assert
      expect(
          result, equals(Left(ServerFailure(errorMessage: "Server failure"))));
    });
  });
}
