import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'signup_usecase_test.mocks.dart';

void main() {
  late SignOutWithFacebookUseCase signOutWithFacebookUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    signOutWithFacebookUseCase =
        SignOutWithFacebookUseCase(repository: mockAuthenticationRepository);
  });

  group('SignOutWithFacebookUseCase', () {
    test('should call the repository to sign out with facebook', () async {
      // Arrange
      when(
        mockAuthenticationRepository.logoutWithFacebook(),
      ).thenAnswer((_) async => const Right(unit));
      // Act
      final result = await signOutWithFacebookUseCase(NoParams());

      // Assert
      expect(result, const Right(unit));
      verify(
        mockAuthenticationRepository.logoutWithFacebook(),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
