import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'signup_usecase_test.mocks.dart';

void main() {
  late SignOutWithGoogleUseCase signOutWithGoogleUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    signOutWithGoogleUseCase =
        SignOutWithGoogleUseCase(repository: mockAuthenticationRepository);
  });

  group('SignOutWithGoogleUseCase', () {
    test('should call the repository to sign out with google', () async {
      // Arrange
      when(
        mockAuthenticationRepository.logoutWithGoogle(),
      ).thenAnswer((_) async => const Right(unit));
      // Act
      final result = await signOutWithGoogleUseCase(NoParams());

      // Assert
      expect(result, const Right(unit));
      verify(
        mockAuthenticationRepository.logoutWithGoogle(),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
