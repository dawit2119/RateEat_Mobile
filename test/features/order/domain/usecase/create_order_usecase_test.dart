import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

import 'create_order_usecase_test.mocks.dart';

@GenerateMocks([OrderRepository])
void main() {
  late CreateOrderUseCase createOrderUseCase;
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    createOrderUseCase =
        CreateOrderUseCase(orderRepository: mockOrderRepository);
  });

  group('CreateOrderUseCase', () {
    final orderModel = OrderModel(
      id: 'orderId123',
      restaurantId: 'restaurantId456',
      restaurantName: 'Sample Restaurant',
      orderStatus: 'Pending',
      orderType: 'Delivery',
      totalPrice: 29.99,
      totalNumberOfItems: 2,
      estimatedWaitingTime: 30,
      orderMessage: 'Leave at the door',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      orderItems: const [
        OrderItemModel(itemId: 'item1', quantity: 1),
        OrderItemModel(itemId: 'item2', quantity: 1),
      ],
    );

    final params = CreateOrderUseCaseParams(order: orderModel);

    test('should return OrderEntity when order is successfully created',
        () async {
      // Arrange: Set up the mock repository to return an OrderEntity
      when(mockOrderRepository.createOrder(orderModel))
          .thenAnswer((_) async => Right(orderModel));

      // Act: Call the use case
      final result = await createOrderUseCase(params);

      // Assert: Verify the result is a success with the created order
      expect(result, Right(orderModel));
      verify(mockOrderRepository.createOrder(orderModel)).called(1);
      verifyNoMoreInteractions(mockOrderRepository);
    });

    test('should return Failure when creating order fails', () async {
      // Arrange: Set up the mock repository to return a Failure
      final failure = ServerFailure();
      when(mockOrderRepository.createOrder(orderModel))
          .thenAnswer((_) async => Left(failure));

      // Act: Call the use case
      final result = await createOrderUseCase(params);

      // Assert: Verify the result is a failure
      expect(result, Left(failure));
      verify(mockOrderRepository.createOrder(orderModel)).called(1);
      verifyNoMoreInteractions(mockOrderRepository);
    });
  });
}
