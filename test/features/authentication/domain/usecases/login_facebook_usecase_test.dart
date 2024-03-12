import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

import 'signup_usecase_test.mocks.dart';

void main() {
  late LoginFacebookUseCase loginFacebookUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    loginFacebookUseCase =
        LoginFacebookUseCase(repository: mockAuthenticationRepository);
  });
  const user = LoginEmailParams(
      accessToken: "s2s2",
      email: "john@example",
      firstName: "John",
      lastName: "Doe");
  final testResponse = UserLoginResponse(
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

  group('LoginWithFacebookUseCase', () {
    test('should call the repository to Login with Facebook', () async {
      // Arrange
      when(
        mockAuthenticationRepository.loginFacebook(
          accessToken: user.accessToken,
        ),
      ).thenAnswer((_) async => Right(testResponse));

      // Act
      final result = await loginFacebookUseCase(user);

      // Assert
      expect(result, Right(testResponse));
      verify(
        mockAuthenticationRepository.loginFacebook(
          accessToken: user.accessToken,
        ),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
