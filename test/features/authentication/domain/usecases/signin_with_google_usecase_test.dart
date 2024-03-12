import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'signup_usecase_test.mocks.dart';

void main() {
  late SignInWithGoogleUseCase signInWithGoogleUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    signInWithGoogleUseCase =
        SignInWithGoogleUseCase(repository: mockAuthenticationRepository);
  });
  final user = UserModel(
    id: "1",
    telegramId: "1",
    facebookId: "1",
    userName: "John",
    firstName: 'John',
    lastName: 'Doe',
    dateOfBirth: '2013-04-20 12:00:00',
    email: 'doe@example',
  );

  group('SignInWithGoogleUseCase', () {
    test('should call the repository to Sign in with Google', () async {
      // Arrange
      when(
        mockAuthenticationRepository.signInWithGoogle(),
      ).thenAnswer((_) async => Right(user));

      // Act
      final result = await signInWithGoogleUseCase(NoParams());

      // Assert
      expect(result, Right(user));
      verify(
        mockAuthenticationRepository.signInWithGoogle(),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
