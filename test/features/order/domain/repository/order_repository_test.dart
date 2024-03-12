import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

import 'order_repository_test.mocks.dart';

@GenerateMocks([OrderRepository])
void main() {
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
  });

  group('OrderRepository', () {
    test('should return total price when getTotalOrderPrice is called',
        () async {
      // Arrange
      final cart = {
        Item(itemId: '1', itemName: 'Pizza', numberOfReviews: 10): 2
      };
      final totalPrice = TotalPrice(totalItems: 2, totalPrice: 250);
      when(mockOrderRepository.getTotalOrderPrice(cart))
          .thenAnswer((_) async => Right(totalPrice));

      // Act
      final result = await mockOrderRepository.getTotalOrderPrice(cart);

      // Assert
      expect(result, Right(totalPrice));
      verify(mockOrderRepository.getTotalOrderPrice(cart)).called(1);
    });

    test('should return OrderEntity when createOrder is successful', () async {
      // Arrange
      final order = OrderModel(
          id: '123',
          totalPrice: 50.0,
          totalNumberOfItems: 3,
          estimatedWaitingTime: 20,
          orderMessage: 'test',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          orderItems: []);
      final orderEntity = OrderEntity(
          id: '123',
          totalPrice: 50.0,
          totalNumberOfItems: 3,
          estimatedWaitingTime: 10,
          orderMessage: 'test',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          orderItems: []);
      when(mockOrderRepository.createOrder(order))
          .thenAnswer((_) async => Right(orderEntity));

      // Act
      final result = await mockOrderRepository.createOrder(order);

      // Assert
      expect(result, Right(orderEntity));
      verify(mockOrderRepository.createOrder(order)).called(1);
    });

    test('should return Failure when createOrder fails', () async {
      // Arrange
      final order = OrderModel(
          id: '123',
          totalPrice: 50.0,
          totalNumberOfItems: 3,
          estimatedWaitingTime: 20,
          orderMessage: 'test',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          orderItems: []);
      when(mockOrderRepository.createOrder(order))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final result = await mockOrderRepository.createOrder(order);

      // Assert
      expect(result, isA<Left>());
      verify(mockOrderRepository.createOrder(order)).called(1);
    });

    test('should return a success message when payment is successful',
        () async {
      // Arrange
      final paymentInfo = PaymentRequestModel(
          orderId: '123', firstName: 'John', lastName: 'Doe');
      when(mockOrderRepository.pay(paymentInfo: paymentInfo))
          .thenAnswer((_) async => Right('Payment successful'));

      // Act
      final result = await mockOrderRepository.pay(paymentInfo: paymentInfo);

      // Assert
      expect(result, Right('Payment successful'));
      verify(mockOrderRepository.pay(paymentInfo: paymentInfo)).called(1);
    });

    test('should return true when order cancellation is successful', () async {
      // Arrange
      when(mockOrderRepository.cancelOrder(
              orderId: '123', reason: 'Changed mind'))
          .thenAnswer((_) async => Right(true));

      // Act
      final result = await mockOrderRepository.cancelOrder(
          orderId: '123', reason: 'Changed mind');

      // Assert
      expect(result, Right(true));
      verify(mockOrderRepository.cancelOrder(
              orderId: '123', reason: 'Changed mind'))
          .called(1);
    });

    test('should return OrderModel when getOrderStatus is called', () async {
      // Arrange
      final order = OrderModel(
          id: '123',
          totalPrice: 50.0,
          totalNumberOfItems: 3,
          estimatedWaitingTime: 20,
          orderMessage: 'test',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          orderItems: []);
      when(mockOrderRepository.getOrderStatus(orderId: '123'))
          .thenAnswer((_) async => Right(order));

      // Act
      final result = await mockOrderRepository.getOrderStatus(orderId: '123');

      // Assert
      expect(result, Right(order));
      verify(mockOrderRepository.getOrderStatus(orderId: '123')).called(1);
    });
  });
}
