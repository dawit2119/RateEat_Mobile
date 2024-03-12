import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import 'signup_usecase_test.mocks.dart';

void main() {
  late SendEditPhoneOtpUseCase sendEditPhoneOtpUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    sendEditPhoneOtpUseCase =
        SendEditPhoneOtpUseCase(repository: mockAuthenticationRepository);
  });

  const testPhoneNumber = SendEditPhoneOtpParams(phoneNumber: '1234567890');

  group('SendEditPhoneOtpUseCase', () {
    test(
        'should call the repository that sends otp to phone number when editing profile',
        () async {
      // Arrange
      when(
        mockAuthenticationRepository.sendEditPhoneOtp(
          phoneNumber: testPhoneNumber.phoneNumber,
        ),
      ).thenAnswer((_) async => const Right(unit));
      // Act
      final result = await sendEditPhoneOtpUseCase(testPhoneNumber);

      // Assert
      expect(result, const Right(unit));
      verify(
        mockAuthenticationRepository.sendEditPhoneOtp(
          phoneNumber: testPhoneNumber.phoneNumber,
        ),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
