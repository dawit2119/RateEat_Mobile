import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/entities/order_detail_entity.dart';

void main() {
  group('OrderDetailEntity Tests', () {
    final orderItemImage =
        OrderItemImageEntity(url: 'https://example.com/image.jpg');
    final orderItemInfo = OrderItemInfoEntity(
        name: 'Pizza', price: 20, itemImages: [orderItemImage]);
    final orderDetailItem = OrderDetailItemEntity(
        id: 'item_1', itemId: 'pizza_1', quantity: 2, item: orderItemInfo);

    final orderDetail = OrderDetailEntity(
      id: 'order_123',
      restaurantId: 'rest_456',
      restaurantName: 'Good Food',
      orderStatus: 'pending',
      orderType: 'delivery',
      totalPrice: 40,
      totalNumberOfItems: 2,
      estimatedWaitingTime: 30,
      orderMessage: 'Extra cheese',
      createdAt: DateTime.parse('2024-02-18T12:00:00.000Z'),
      updatedAt: DateTime.parse('2024-02-18T12:30:00.000Z'),
      orderItems: [orderDetailItem],
      orderConfirmedAt: null,
      paymentConfirmedAt: null,
      orderPlacedAt: DateTime.parse('2024-02-18T12:05:00.000Z'),
      orderCompletedAt: null,
      orderRejectedAt: null,
      orderCanceledAt: null,
    );

    test('should support value equality', () {
      final orderDetailDuplicate = OrderDetailEntity(
        id: 'order_123',
        restaurantId: 'rest_456',
        restaurantName: 'Good Food',
        orderStatus: 'pending',
        orderType: 'delivery',
        totalPrice: 40,
        totalNumberOfItems: 2,
        estimatedWaitingTime: 30,
        orderMessage: 'Extra cheese',
        createdAt: DateTime.parse('2024-02-18T12:00:00.000Z'),
        updatedAt: DateTime.parse('2024-02-18T12:30:00.000Z'),
        orderItems: [orderDetailItem],
        orderConfirmedAt: null,
        paymentConfirmedAt: null,
        orderPlacedAt: DateTime.parse('2024-02-18T12:05:00.000Z'),
        orderCompletedAt: null,
        orderRejectedAt: null,
        orderCanceledAt: null,
      );
      expect(orderDetail, equals(orderDetailDuplicate));
    });
  });
}
