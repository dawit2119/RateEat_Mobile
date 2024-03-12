import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import 'signup_usecase_test.mocks.dart';

void main() {
  late LogoutUseCase logoutUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    logoutUseCase = LogoutUseCase(repository: mockAuthenticationRepository);
  });

  group('LogoutUseCase', () {
    test('should call the repository that logout the user', () async {
      // Arrange
      when(
        mockAuthenticationRepository.logout(),
      ).thenAnswer((_) async => const Right(unit));
      // Act
      final result = await logoutUseCase(NoParams());

      // Assert
      expect(result, const Right(unit));
      verify(
        mockAuthenticationRepository.logout(),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
