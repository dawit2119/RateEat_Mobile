import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

import 'signup_usecase_test.mocks.dart';

void main() {
  late VerifyOtpUseCase verifyOtpUseCase;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    verifyOtpUseCase =
        VerifyOtpUseCase(repository: mockAuthenticationRepository);
  });

  const verifyParams =
      VerifyOtpParams(phoneNumber: '1234567890', code: '123456');

  final testResponse = UserLoginResponse(
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
    statusCode: 200,
  );

  group('VerifyOtpUseCase', () {
    test('should call the repository that verify phone number with otp code',
        () async {
      // Arrange
      when(
        mockAuthenticationRepository.verifyOtp(
          phoneNumber: verifyParams.phoneNumber,
          code: verifyParams.code,
        ),
      ).thenAnswer((_) async => Right(testResponse));
      // Act
      final result = await verifyOtpUseCase(verifyParams);

      // Assert
      expect(result, Right(testResponse));
      verify(
        mockAuthenticationRepository.verifyOtp(
          phoneNumber: verifyParams.phoneNumber,
          code: verifyParams.code,
        ),
      );
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });
}
