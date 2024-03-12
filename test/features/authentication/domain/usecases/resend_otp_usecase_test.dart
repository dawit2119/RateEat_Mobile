import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'signup_usecase_test.mocks.dart';

void main() {
  late ResendOtpUseCase resendOtpUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    resendOtpUseCase =
        ResendOtpUseCase(repository: mockAuthenticationRepository);
  });

  const testPhoneNumber = ResendOtpParams(phoneNumber: '1234567890');

  group('ResendOtpUseCase', () {
    test('should call the repository to resend otp to phone number', () async {
      // Arrange
      when(
        mockAuthenticationRepository.resendOtp(
          phoneNumber: testPhoneNumber.phoneNumber,
        ),
      ).thenAnswer((_) async => const Right(unit));
      // Act
      final result = await resendOtpUseCase(testPhoneNumber);

      // Assert
      expect(result, const Right(unit));
      verify(
        mockAuthenticationRepository.resendOtp(
            phoneNumber: testPhoneNumber.phoneNumber),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
