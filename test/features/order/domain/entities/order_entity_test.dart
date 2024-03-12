import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

void main() {
  group('OrderEntity', () {
    test('should create an instance with required fields', () {
      final order = OrderEntity(
        id: '123',
        restaurantId: 'resto_1',
        restaurantName: 'Test Resto',
        orderStatus: 'pending',
        orderType: 'dine-in',
        totalPrice: 50.0,
        totalNumberOfItems: 3,
        estimatedWaitingTime: 15,
        orderMessage: 'No onions',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        orderItems: [],
      );

      expect(order.totalPrice, 50.0);
      expect(order.totalNumberOfItems, 3);
      expect(order.orderStatus, 'pending');
    });

    test('should support value equality using Equatable', () {
      final now = DateTime.now();
      final order1 = OrderEntity(
        id: '123',
        restaurantId: 'resto_1',
        restaurantName: 'Test Resto',
        orderStatus: 'pending',
        orderType: 'dine-in',
        totalPrice: 50.0,
        totalNumberOfItems: 3,
        estimatedWaitingTime: 15,
        orderMessage: 'No onions',
        createdAt: now,
        updatedAt: now,
        orderItems: [],
      );

      final order2 = OrderEntity(
        id: '123',
        restaurantId: 'resto_1',
        restaurantName: 'Test Resto',
        orderStatus: 'pending',
        orderType: 'dine-in',
        totalPrice: 50.0,
        totalNumberOfItems: 3,
        estimatedWaitingTime: 15,
        orderMessage: 'No onions',
        createdAt: now,
        updatedAt: now,
        orderItems: [],
      );

      expect(order1, equals(order2));
    });

    test('should differentiate two different orders', () {
      final order1 = OrderEntity(
        id: '123',
        restaurantId: 'resto_1',
        restaurantName: 'Test Resto',
        orderStatus: 'pending',
        orderType: 'dine-in',
        totalPrice: 50.0,
        totalNumberOfItems: 3,
        estimatedWaitingTime: 15,
        orderMessage: 'No onions',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        orderItems: [],
      );

      final order2 = OrderEntity(
        id: '124', // Different ID
        restaurantId: 'resto_2',
        restaurantName: 'Another Resto',
        orderStatus: 'completed',
        orderType: 'takeaway',
        totalPrice: 20.0,
        totalNumberOfItems: 1,
        estimatedWaitingTime: 5,
        orderMessage: 'Extra spicy',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        orderItems: [],
      );

      expect(order1, isNot(equals(order2)));
    });

    test('should allow null values for optional fields', () {
      final order = OrderEntity(
        id: null,
        restaurantId: null,
        restaurantName: null,
        orderStatus: null,
        orderType: null,
        totalPrice: 100.0,
        totalNumberOfItems: 2,
        estimatedWaitingTime: 10,
        orderMessage: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        orderItems: [],
        orderConfirmedAt: null,
        paymentConfirmedAt: null,
        orderPlacedAt: null,
        orderCompletedAt: null,
        orderRejectedAt: null,
        orderCanceledAt: null,
      );

      expect(order.id, isNull);
      expect(order.restaurantId, isNull);
      expect(order.orderConfirmedAt, isNull);
    });
  });
}
