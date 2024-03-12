import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'get_order_status_usecase_test.mocks.dart';

// Generate mock for OrderRepository
@GenerateMocks([OrderRepository])
void main() {
  late GetOrderStatusUseCase getOrderStatusUseCase;
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    getOrderStatusUseCase =
        GetOrderStatusUseCase(orderRepository: mockOrderRepository);
  });

  const tOrderId = '123';
  final tOrder = OrderModel(
    id: tOrderId,
    restaurantId: 'res123',
    restaurantName: 'Sample Restaurant',
    orderStatus: 'Processing',
    orderType: 'Delivery',
    totalPrice: 50.0,
    totalNumberOfItems: 3,
    estimatedWaitingTime: 30,
    orderMessage: 'Handle with care',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    orderItems: const [],
  );

  const tParams = GetOrderStatusParams(orderId: tOrderId);

  test('should return OrderModel when repository call is successful', () async {
    // Arrange
    when(mockOrderRepository.getOrderStatus(orderId: tOrderId))
        .thenAnswer((_) async => Right(tOrder));

    // Act
    final result = await getOrderStatusUseCase(tParams);

    // Assert
    expect(result, Right(tOrder));
    verify(mockOrderRepository.getOrderStatus(orderId: tOrderId)).called(1);
    verifyNoMoreInteractions(mockOrderRepository);
  });

  test('should return Failure when repository call fails', () async {
    // Arrange
    final tFailure = ServerFailure();
    when(mockOrderRepository.getOrderStatus(orderId: tOrderId))
        .thenAnswer((_) async => Left(tFailure));

    // Act
    final result = await getOrderStatusUseCase(tParams);

    // Assert
    expect(result, Left(tFailure));
    verify(mockOrderRepository.getOrderStatus(orderId: tOrderId)).called(1);
    verifyNoMoreInteractions(mockOrderRepository);
  });
}
