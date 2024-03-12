import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/domain/entities/order_status.dart';

void main() {
  group('test order status', () {
    test('should create instance with required fields', () {
      final order = Order(
          orderId: '12',
          time: '12:30 pm',
          title: 'pizza',
          isCompleted: true,
          isCurrent: true);

      expect(order.time, '12:30 pm');
      expect(order.title, 'pizza');
      expect(order.isCompleted, true);
    });

    test('should allow diffrent values for isCompelted and isCurrent', () {
      final order1 = Order(
          orderId: '12',
          time: '12:30 pm',
          title: 'pizza',
          isCompleted: false,
          isCurrent: true);

      final order2 = Order(
          orderId: '12',
          time: '12:30 pm',
          title: 'pizza',
          isCompleted: false,
          isCurrent: true);

      expect(order1.isCompleted, false);
      expect(order2.isCurrent, true);
    });

    test('should support value equality using Equatable', () {
      final order1 = Order(
          orderId: '12',
          time: '12:30 pm',
          title: 'pizza',
          isCompleted: true,
          isCurrent: true);

      final order2 = Order(
          orderId: '12',
          time: '12:30 pm',
          title: 'pizza',
          isCompleted: true,
          isCurrent: true);

      expect(order1, equals(order2));
    });
  });
}
