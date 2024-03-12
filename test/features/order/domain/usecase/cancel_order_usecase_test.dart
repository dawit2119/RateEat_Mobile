import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/domain/domain.dart';

import 'cancel_order_usecase_test.mocks.dart';

@GenerateMocks([OrderRepository])
void main() {
  late CancelOrderUseCase cancelOrderUseCase;
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    cancelOrderUseCase =
        CancelOrderUseCase(orderRepository: mockOrderRepository);
  });

  group('CancelOrderUseCase', () {
    const orderId = 'orderId123';
    const reason = 'User requested cancellation';

    final params = CancelOrderUseCaseParams(orderId: orderId, reason: reason);

    test('should return true when order is successfully canceled', () async {
      // Arrange: Set up the mock repository to return success
      when(mockOrderRepository.cancelOrder(orderId: orderId, reason: reason))
          .thenAnswer((_) async => const Right(true));

      // Act: Call the use case
      final result = await cancelOrderUseCase(params);

      // Assert: Verify the result is a success with value `true`
      expect(result, const Right(true));
      verify(mockOrderRepository.cancelOrder(orderId: orderId, reason: reason))
          .called(1);
      verifyNoMoreInteractions(mockOrderRepository);
    });

    test('should return Failure when cancellation fails', () async {
      // Arrange: Set up the mock repository to return a failure
      final failure = ServerFailure();
      when(mockOrderRepository.cancelOrder(orderId: orderId, reason: reason))
          .thenAnswer((_) async => Left(failure));

      // Act: Call the use case
      final result = await cancelOrderUseCase(params);

      // Assert: Verify the result is a failure
      expect(result, Left(failure));
      verify(mockOrderRepository.cancelOrder(orderId: orderId, reason: reason))
          .called(1);
      verifyNoMoreInteractions(mockOrderRepository);
    });
  });
}
