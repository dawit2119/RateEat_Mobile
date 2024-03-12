import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

import 'signup_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationRepository>(),
])
void main() {
  late SignupUseCase signupUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    signupUseCase = SignupUseCase(repository: mockAuthenticationRepository);
  });

  final testUser = SignUpParams(
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
  );

  final userResponse = UserModel(
    id: "1",
    telegramId: "1",
    facebookId: "1",
    userName: "John",
    firstName: 'John',
    lastName: 'Doe',
    dateOfBirth: '2013-04-20 12:00:00',
    email: 'doe@example',
  );

  group('SendEditEmailOtpUseCase', () {
    test('should call the repository to perform signup', () async {
      // Arrange
      when(
        mockAuthenticationRepository.signUp(
          userData: testUser.user,
        ),
      ).thenAnswer((_) async => Right(userResponse));
      // Act
      final result = await signupUseCase(testUser);

      // Assert
      expect(result, Right(userResponse));
      verify(
        mockAuthenticationRepository.signUp(
          userData: testUser.user,
        ),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
