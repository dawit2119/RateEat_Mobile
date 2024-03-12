import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/usecases/delete_account_usecase.dart';

import 'signup_usecase_test.mocks.dart';

void main() {
  late DeleteAccountUseCase deleteAccountUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    deleteAccountUseCase =
        DeleteAccountUseCase(repository: mockAuthenticationRepository);
  });

  group('LogoutUseCase', () {
    test('should call the repository that deletes the user account', () async {
      // Arrange
      when(
        mockAuthenticationRepository.deleteAccount(),
      ).thenAnswer((_) async => const Right(unit));
      // Act
      final result = await deleteAccountUseCase(NoParams());

      // Assert
      expect(result, const Right(unit));
      verify(
        mockAuthenticationRepository.deleteAccount(),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
