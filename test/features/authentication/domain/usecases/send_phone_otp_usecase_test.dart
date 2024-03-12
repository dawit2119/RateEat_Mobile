import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import 'signup_usecase_test.mocks.dart';

void main() {
  late SendPhoneOtpUseCase sendPhoneOtpUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    sendPhoneOtpUseCase =
        SendPhoneOtpUseCase(repository: mockAuthenticationRepository);
  });

  const testPhoneNumber = SendPhoneOtpParams(phoneNumber: '1234567890');

  group('SendPhoneOtpUseCase', () {
    test('should call the repository to send otp to phone number', () async {
      // Arrange
      when(
        mockAuthenticationRepository.sendPhoneOtp(
            phoneNumber: testPhoneNumber.phoneNumber),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await sendPhoneOtpUseCase(testPhoneNumber);

      // Assert
      expect(result, const Right(unit));
      verify(
        mockAuthenticationRepository.sendPhoneOtp(
            phoneNumber: testPhoneNumber.phoneNumber),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
