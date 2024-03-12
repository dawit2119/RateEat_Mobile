import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import 'signup_usecase_test.mocks.dart';

void main() {
  late SendEditEmailOtpUseCase sendEditEmailOtpUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    sendEditEmailOtpUseCase =
        SendEditEmailOtpUseCase(repository: mockAuthenticationRepository);
  });

  const testEmail = SendEditEmailOtpParams(email: 'test@example.com');

  group('SendEditEmailOtpUseCase', () {
    test(
        'should call the repository that sends otp to email when editing profile',
        () async {
      // Arrange
      when(
        mockAuthenticationRepository.sendEditEmailOtp(
          email: testEmail.email,
        ),
      ).thenAnswer((_) async => const Right(unit));
      // Act
      final result = await sendEditEmailOtpUseCase(testEmail);

      // Assert
      expect(result, const Right(unit));
      verify(
        mockAuthenticationRepository.sendEditEmailOtp(
          email: testEmail.email,
        ),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
