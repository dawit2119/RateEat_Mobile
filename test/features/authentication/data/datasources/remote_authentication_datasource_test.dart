import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/exception.dart';
import 'package:rateeat_mobile/src/core/hive/hive_init.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/user_model.dart';
import 'dart:convert';

import '../../../../helper/json_reader.dart';
import 'remote_authentication_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<HiveService>(),
  MockSpec<AuthenticationLocalSource>(),
])
void main() {
  late MockDio mockDio;
  late MockHiveService mockHiveService;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  late RemoteAuthenticationSourceImpl remoteAuthenticationSourceImpl;
  late String baseURL;

  setUp(() async {
    await dotenv.load(fileName: ".env");
    mockDio = MockDio();
    baseURL = dotenv.get('BASE_URL');
    mockHiveService = MockHiveService();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    remoteAuthenticationSourceImpl = RemoteAuthenticationSourceImpl(
      dio: mockDio,
      service: mockHiveService,
      localSource: mockAuthenticationLocalSource,
    );
  });

  final testUser = UserModel(
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    phoneNumber: '0987654321',
    gender: 'male',
    fcmToken: 'fcmToken',
  );

  group('login with google', () {
    test(
        'should return a User from his gmail account when the call to the remote data source is successful',
        () async {
      // arrange
      final body = {
        'email': 'test@example.com',
        'first_name': 'John',
        'last_name': 'Doe',
        'access_token': 'accessToken',
        'role_name': 'user',
        'fcm_token': 'fcmToken',
      };
      when(mockDio.post(
        '$baseURL/auth/register-gmail',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/register-gmail'),
          data: json.decode(
            readJson(
                'test/helper/authentication/user_login_response_test.json'),
          ),
          statusCode: 200,
        ),
      );
      // act
      await expectLater(
        () => remoteAuthenticationSourceImpl.loginGoogle(
          email: testUser.email!,
          firstName: testUser.firstName!,
          lastName: testUser.lastName,
          accessToken: 'accessToken',
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test(
        'should throw an UnauthorizedRequestException when the call to the remote data source is 404',
        () async {
      // Arrange
      when(mockHiveService.getFcmToken()).thenReturn('fcmToken');

      final body = {
        'email': testUser.email,
        'first_name': testUser.firstName,
        'last_name': testUser.lastName,
        'access_token': 'accessToken',
        'role_name': 'user',
        'fcm_token': 'fcmToken',
      };

      when(mockDio.post(
        '$baseURL/auth/register-gmail',
        data: body,
        options: anyNamed('options'),
      )).thenThrow(
        DioException.badResponse(
          requestOptions: RequestOptions(path: '$baseURL/auth/register-gmail'),
          response: Response(
            requestOptions:
                RequestOptions(path: '$baseURL/auth/register-gmail'),
            statusCode: 404,
            data: "Not Found",
          ),
          statusCode: 404,
        ),
      );

      // Act & Assert
      await expectLater(
        remoteAuthenticationSourceImpl.loginGoogle(
          email: testUser.email!,
          firstName: testUser.firstName!,
          lastName: testUser.lastName,
          accessToken: 'accessToken',
        ),
        throwsA(isA<UnauthorizedRequestException>()),
      );
    });

    test(
        'should throw a Server Exception when the call to the remote data source fails',
        () async {
      // arrange
      final body = {
        'email': 'test@example.com',
        'first_name': 'John',
        'last_name': 'Doe',
        'access_token': 'accessToken',
        'role_name': 'user',
        'fcm_token': 'fcmToken',
      };
      when(mockDio.post('$baseURL/auth/register-gmail', data: body)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/register-gmail'),
          data: "Server Error",
          statusCode: 400,
        ),
      );
      // act & assert
      await expectLater(
        () => remoteAuthenticationSourceImpl.loginGoogle(
          email: testUser.email!,
          firstName: testUser.firstName!,
          lastName: testUser.lastName,
          accessToken: 'accessToken',
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
  // group('login with facebook', () {
  //   test(
  //       'should return a User from his facebook account when the call to the remote data source is successful',
  //       () async {
  //     // arrange
  //     final body = {
  //       'email': 'test@example.com',
  //       'first_name': 'John',
  //       'last_name': 'Doe',
  //       'access_token': 'accessToken',
  //       'role_name': 'user',
  //       'fcm_token': 'fcmToken',
  //     };
  //     when(mockDio.post(
  //       '$baseURL/auth/login-facebook',
  //       data: body,
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //     )).thenAnswer(
  //       (_) async => Response(
  //         requestOptions: RequestOptions(path: '$baseURL/auth/login-facebook'),
  //         data: json.decode(
  //           readJson('authentication/user_login_response_test.json'),
  //         ),
  //         statusCode: 200,
  //       ),
  //     );
  //     // act
  //     final result = await remoteAuthenticationSourceImpl.loginFacebook(
  //       accessToken: 'accessToken',
  //     );
  //     // assert
  //     expect(result, isA<UserModel>());
  //   });

  //   test(
  //       'should throw a unauthorized Exception when the call to the remote data source is 404',
  //       () async {
  //     // arrange
  //     final body = {
  //       'email': 'test@example.com',
  //       'first_name': 'John',
  //       'last_name': 'Doe',
  //       'access_token': 'accessToken',
  //       'role_name': 'user',
  //       'fcm_token': 'fcmToken',
  //     };
  //     when(mockDio.post('$baseURL/auth/login-facebook', data: body)).thenAnswer(
  //       (_) async => Response(
  //         requestOptions: RequestOptions(path: '$baseURL/auth/login-facebook'),
  //         data: "Not Found",
  //         statusCode: 404,
  //       ),
  //     );
  //     // act
  //     final result = await remoteAuthenticationSourceImpl.loginFacebook(
  //       accessToken: 'accessToken',
  //     );
  //     // assert
  //     expect(result, throwsA(isA<UnauthorizedRequestException>()));
  //   });

  //   test(
  //       'should throw a Server Exception when the call to the remote data source fails',
  //       () async {
  //     // arrange
  //     final body = {
  //       'email': 'test@example.com',
  //       'first_name': 'John',
  //       'last_name': 'Doe',
  //       'access_token': 'accessToken',
  //       'role_name': 'user',
  //       'fcm_token': 'fcmToken',
  //     };
  //     when(mockDio.post('$baseURL/auth/login-facebook', data: body)).thenAnswer(
  //       (_) async => Response(
  //         requestOptions: RequestOptions(path: '$baseURL/auth/login-facebook'),
  //         data: "Server Error",
  //         statusCode: 400,
  //       ),
  //     );
  //     // act
  //     final result = await remoteAuthenticationSourceImpl.loginFacebook(
  //       accessToken: 'accessToken',
  //     );
  //     // assert
  //     expect(result, throwsA(const TypeMatcher<ServerException>()));
  //     // expect(result, throwsA(isA<ServerException>()));
  //   });
  // });
  group('sign up', () {
    test(
        'should return a User when the call to the remote data source is successful',
        () async {
      // arrange
      final body = {
        'email': 'test@example.com',
        'phone_number': '1234567890',
        'gender': 'male',
        'first_name': 'John',
        'last_name': 'Doe',
        'access_token': 'accessToken',
        'role_name': 'user',
      };
      when(mockDio.post(
        '$baseURL/auth/register',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/register'),
          data: json.decode(
            readJson('authentication/user_login_response_test.json'),
          ),
          statusCode: 200,
        ),
      );
      // act
      expectLater(
        () => remoteAuthenticationSourceImpl.signUp(
          user: testUser,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test(
        'should throw a server exception when the call to the remote data source is 404',
        () async {
      // arrange
      when(mockHiveService.getFcmToken()).thenReturn('fcmToken');

      final formData = FormData.fromMap({
        'first_name': testUser.firstName,
        'last_name': testUser.lastName,
        'role_name': 'user',
        'fcm_token': 'fcmToken',
        'email': testUser.email,
        'phone_number': testUser.phoneNumber,
        'gender': testUser.gender,
      });

      when(mockDio.post(
        '$baseURL/auth/register',
        data: formData,
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '$baseURL/auth/register'),
          response: Response(
            requestOptions: RequestOptions(path: '$baseURL/auth/register'),
            statusCode: 404,
            data: {'message': 'Not Found'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      // act & assert
      await expectLater(
        () => remoteAuthenticationSourceImpl.signUp(user: testUser),
        throwsA(isA<ServerException>()),
      );
    });

    test(
        'should throw a Server Exception when the call to the remote data source fails',
        () async {
      // arrange
      final body = {
        'email': 'test@example.com',
        'first_name': 'John',
        'last_name': 'Doe',
        'access_token': 'accessToken',
        'role_name': 'user',
      };
      when(mockDio.post('$baseURL/auth/register', data: body)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/register'),
          data: "Server Error",
          statusCode: 400,
        ),
      );
      // act

      // assert
      expectLater(
        () => remoteAuthenticationSourceImpl.signUp(
          user: testUser,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
  group('send otp to phone', () {
    test('should send otp to phone', () async {
      // arrange
      when(mockHiveService.getFcmToken()).thenReturn('fcmToken');

      final body = {
        'phone': testUser.phoneNumber,
        'fcm_token': 'fcmToken',
      };

      when(mockDio.post(
        '$baseURL/auth/send-otp',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/send-otp'),
          statusCode: 200,
        ),
      );

      // act & assert
      await expectLater(
        () => remoteAuthenticationSourceImpl.sendPhoneOtp(
          phoneNumber: testUser.phoneNumber!,
        ),
        isA<void>(),
      );
    });

    test(
        'should throw a Server Exception when the call to the remote data source fails',
        () async {
      // arrange
      final body = {
        'phone': testUser.phoneNumber,
        'fcm_token': testUser.token,
      };
      when(mockDio.post('$baseURL/auth/send-otp', data: body)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/send-otp'),
          data: "Server Error",
          statusCode: 404,
        ),
      );
      // act & assert
      expectLater(
        () => remoteAuthenticationSourceImpl.sendPhoneOtp(
          phoneNumber: testUser.phoneNumber!,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
  group('send otp to phone when editing profile', () {
    test('should send otp to phone when editing profile phone field', () async {
      // arrange
      when(mockHiveService.getFcmToken()).thenReturn('fcmToken');

      final body = {
        'phone': testUser.phoneNumber,
        'fcm_token': 'fcmToken',
      };

      when(mockDio.post(
        '$baseURL/auth/send-otp-to-user',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      )).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '$baseURL/auth/send-otp-to-user'),
          data: {
            'status': true,
            'message': 'OTP sent successfully'
          }, // Added proper response structure
          statusCode: 200,
        ),
      );

      // act & assert
      await expectLater(
        () => remoteAuthenticationSourceImpl.sendEditPhoneOtp(
          phoneNumber: testUser.phoneNumber!,
        ),
        isA<void>(),
      );
    });

    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      final body = {
        'phone': testUser.phoneNumber,
        'fcm_token': testUser.token,
      };
      when(mockDio.post('$baseURL/auth/send-otp-to-user', data: body))
          .thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '$baseURL/auth/send-otp-to-user'),
          data: "Server Error",
          statusCode: 404,
        ),
      );
      // act
      await expectLater(
        () => remoteAuthenticationSourceImpl.sendEditPhoneOtp(
          phoneNumber: testUser.phoneNumber!,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
  group('send otp to Email when editing profile', () {
    test('should send otp to email when editing profile email field', () async {
      // arrange
      final body = {
        'gmail': testUser.email,
        'fcm_token': testUser.token,
      };
      when(mockDio.post(
        '$baseURL/auth/send-otp-to-user',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      )).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '$baseURL/auth/send-otp-to-user'),
          statusCode: 200,
        ),
      );
      // act
      await expectLater(
        () => remoteAuthenticationSourceImpl.sendEditEmailOtp(
          email: testUser.email!,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test(
        'should return a Server failure when the call to the remote data source fails',
        () async {
      // arrange
      final body = {
        'gmail': testUser.email,
        'fcm_token': testUser.token,
      };
      when(mockDio.post('$baseURL/auth/send-otp-to-user', data: body))
          .thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '$baseURL/auth/send-otp-to-user'),
          data: "Unauthorized Error",
          statusCode: 400,
        ),
      );
      // act & assert
      expectLater(
        () => remoteAuthenticationSourceImpl.sendEditEmailOtp(
          email: testUser.email!,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
  group('Verify Phone number and login', () {
    test(
      'should return a User from his phone number when the call to the remote data source is successful',
      () async {
        // arrange
        when(mockHiveService.getFcmToken()).thenReturn('fcmToken');

        final body = {
          'phone': testUser.phoneNumber,
          'otp': "1234",
          'role_name': 'user',
          'fcm_token': 'fcmToken',
        };

        final mockUserData = {
          'data': {
            'id': '1',
            'email': 'test@example.com',
            'first_name': 'John',
            'last_name': 'Doe',
            'phone_number': '0987654321',
            'gender': 'male',
            'fcm_token': 'fcmToken',
            'token': 'test_token'
          },
          'status_code': 200
        };

        when(mockDio.post(
          '$baseURL/auth/register-phone',
          data: body,
          options: anyNamed('options'),
        )).thenAnswer(
          (_) async => Response(
            requestOptions:
                RequestOptions(path: '$baseURL/auth/register-phone'),
            data: mockUserData,
            statusCode: 200,
          ),
        );

        // act
        final result = await remoteAuthenticationSourceImpl.verifyOtp(
          phoneNumber: testUser.phoneNumber!,
          code: "1234",
        );

        // assert

        expect(result.user.id, '1');
        expect(result.user.email, 'test@example.com');
      },
    );
    test('should throw UnauthorizedRequestException when status code is 400',
        () async {
      // arrange
      when(mockHiveService.getFcmToken()).thenReturn('fcmToken');

      final body = {
        'phone': testUser.phoneNumber,
        'otp': "1234",
        'role_name': 'user',
        'fcm_token': 'fcmToken',
      };

      when(mockDio.post(
        '$baseURL/auth/register-phone',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/register-phone'),
          statusCode: 400,
          data: {'message': 'Invalid OTP'},
        ),
      );

      // act & assert
      await expectLater(
        () => remoteAuthenticationSourceImpl.verifyOtp(
          phoneNumber: testUser.phoneNumber!,
          code: "1234",
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test(
        'should return a Server Exception when the call to the remote data source fails',
        () async {
      // arrange
      final body = {
        'phone': testUser.phoneNumber,
        'otp': "1234",
        'role_name': 'user',
        'fcm_token': testUser.token,
      };
      when(mockDio.post('$baseURL/auth/register-phone', data: body)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/register-phone'),
          data: "Server Error",
          statusCode: 404,
        ),
      );
      // act
      expectLater(
        () => remoteAuthenticationSourceImpl.verifyOtp(
          phoneNumber: testUser.phoneNumber!,
          code: "1234",
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
  group('resend otp to phone', () {
    test('should resend otp to phone when resend is clicked', () async {
      // arrange
      final body = {
        'phone': testUser.phoneNumber,
        'fcm_token': testUser.token,
      };
      when(mockDio.post('$baseURL/auth/send-otp', data: body)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/send-otp'),
          statusCode: 200,
        ),
      );
      // act
      await expectLater(
        () => remoteAuthenticationSourceImpl.resendOtp(
          phoneNumber: testUser.phoneNumber!,
        ),
        isA<void>(),
      );
    });

    test(
        'should return a Server Exception when the call to the remote data source fails',
        () async {
      // arrange
      final body = {
        'phone': testUser.phoneNumber,
        'fcm_token': testUser.token,
      };
      when(mockDio.post('$baseURL/auth/send-otp', data: body)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/send-otp'),
          data: "Server Error",
          statusCode: 404,
        ),
      );
      // act
      await expectLater(
        () => remoteAuthenticationSourceImpl.resendOtp(
          phoneNumber: testUser.phoneNumber!,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
  group('logout', () {
    test('should logout', () async {
      // arrange
      when(mockDio.get(
        '$baseURL/auth/logout',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/logout'),
          statusCode: 200,
        ),
      );
      // act
      await expectLater(
        () => remoteAuthenticationSourceImpl.logout(),
        isA<void>(),
      );
    });
    test(
        'should return a Server Exception when the call to the remote data source fails',
        () async {
      // arrange

      when(mockDio.get('$baseURL/auth/logout')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/logout'),
          data: "Server Error",
          statusCode: 404,
        ),
      );
      // act
      await expectLater(
        () => remoteAuthenticationSourceImpl.logout(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('delete account', () {
    test('should delete account', () async {
      // arrange
      final user = LocalUserModel(token: 'test_token');
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(user);

      when(mockDio.get(
        '$baseURL/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer test_token',
          },
        ),
      )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/logout'),
          data: {'message': 'Account deleted successfully'},
          statusCode: 200,
        ),
      );

      // act & assert
      await expectLater(
        () => remoteAuthenticationSourceImpl.deleteAccount(),
        isA<void>(),
      );
    });
    test(
        'should return a Server Exception when the call to the remote data source fails',
        () async {
      // arrange

      when(mockDio.delete('$baseURL/auth/delete-account')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '$baseURL/auth/delete-account'),
          data: "Server Error",
          statusCode: 404,
        ),
      );
      // act
      await expectLater(
        () => remoteAuthenticationSourceImpl.deleteAccount(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
