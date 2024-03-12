import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/data/data.dart';
import 'package:rateeat_mobile/src/features/order/domain/domain.dart';

import 'pay_order_usecase_test.mocks.dart';

// Generate a mock OrderRepository
@GenerateMocks([OrderRepository])
void main() {
  late PayOrderUseCase useCase;
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    useCase = PayOrderUseCase(orderRepository: mockOrderRepository);
  });

  group('PayOrderUseCase', () {
    const paymentInfo = PaymentRequestModel(
      orderId: 'order123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      phoneNumber: '123456789',
    );
    final params = PaymentRequestUseCaseParams(paymentInfo: paymentInfo);

    test('should return payment URL when repository call is successful',
        () async {
      // Arrange
      const paymentUrl = 'https://paymentgateway.com/pay';
      when(mockOrderRepository.pay(paymentInfo: anyNamed('paymentInfo')))
          .thenAnswer((_) async => const Right(paymentUrl));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, const Right(paymentUrl));
      verify(mockOrderRepository.pay(paymentInfo: paymentInfo)).called(1);
    });

    test('should return Failure when repository call fails', () async {
      // Arrange
      final failure = ServerFailure();
      when(mockOrderRepository.pay(paymentInfo: anyNamed('paymentInfo')))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, Left(failure));
      verify(mockOrderRepository.pay(paymentInfo: paymentInfo)).called(1);
    });
  });
}
