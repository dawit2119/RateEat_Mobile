import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

import 'signup_usecase_test.mocks.dart';

void main() {
  late LoginGoogleUseCase loginGoogleUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    loginGoogleUseCase =
        LoginGoogleUseCase(repository: mockAuthenticationRepository);
  });
  const user = LoginEmailParams(
    accessToken: "s2s2",
    email: "john@example",
    firstName: "John",
    lastName: "Doe",
  );
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

  group('LoginWithGoogleUseCase', () {
    test('should call the repository to Login with Google', () async {
      // Arrange
      when(
        mockAuthenticationRepository.loginGoogle(
          email: user.email,
          accessToken: user.accessToken,
          firstName: user.firstName,
          lastName: user.lastName,
        ),
      ).thenAnswer((_) async => Right(testResponse));

      // Act
      final result = await loginGoogleUseCase(user);
      // Assert
      expect(result, Right(testResponse));
      verify(
        mockAuthenticationRepository.loginGoogle(
          email: user.email,
          accessToken: user.accessToken,
          firstName: user.firstName,
          lastName: user.lastName,
        ),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
