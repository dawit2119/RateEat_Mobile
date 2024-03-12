import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/order/domain/entities/order_item.dart';

void main() {
  group('OrderItem', () {
    test('should create an instance with required fields', () {
      const orderItem = OrderItem(itemId: 'item123', quantity: 2);

      expect(orderItem.itemId, 'item123');
      expect(orderItem.quantity, 2);
    });

    test('should support value equality using Equatable', () {
      const orderItem1 = OrderItem(itemId: 'item123', quantity: 2);
      const orderItem2 = OrderItem(itemId: 'item123', quantity: 2);

      expect(orderItem1, equals(orderItem2));
    });

    test('should differentiate two different items', () {
      const orderItem1 = OrderItem(itemId: 'item123', quantity: 2);
      const orderItem2 = OrderItem(itemId: 'item124', quantity: 2);

      expect(orderItem1, isNot(equals(orderItem2)));

      const orderItem3 = OrderItem(itemId: 'item123', quantity: 3);
      expect(orderItem1, isNot(equals(orderItem3)));
    });
  });
}
