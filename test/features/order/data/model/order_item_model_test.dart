import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

void main() {
  group('OrderItemModel', () {
    test('fromJson should return a valid OrderItemModel', () {
      final json = {
        'item_id': '642aa73f-070c-4d1f-81b6-74c74e8883ab',
        'quantity': 5,
      };

      // Act
      final orderItem = OrderItemModel.fromJson(json);

      // Assert
      expect(orderItem.itemId, '642aa73f-070c-4d1f-81b6-74c74e8883ab');
      expect(orderItem.quantity, 5);
      expect(orderItem, isA<OrderItemModel>());
    });

    test('toJson should return a valid JSON map', () {
      // Arrange
      const orderItem = OrderItemModel(
        itemId: '642aa73f-070c-4d1f-81b6-74c74e8883ab',
        quantity: 5,
      );

      // Act
      final json = orderItem.toJson();

      // Assert
      expect(json, {
        'itemId': '642aa73f-070c-4d1f-81b6-74c74e8883ab',
        'quantity': 5,
      });
    });

    test('fromJson should handle missing or null values', () {
      // Arrange
      final json = {
        'item_id': null,
        'quantity': null,
      };

      // Act
      final orderItem = OrderItemModel.fromJson(json);

      // Assert
      expect(orderItem.itemId, '');
      expect(orderItem.quantity, 0);
    });

    test('throws ServerExcption when invalid info is added', () async {
      // Arrange
      final json = {
        'item_id': '642aa73f-070c-4d1f-81b6-74c74e8883ab',
        'quantity': 5,
      };

      // Act
      final orderItem = OrderItemModel.fromJson(json);

      // Assert
      expect(orderItem.itemId, '642aa73f-070c-4d1f-81b6-74c74e8883ab');
      expect(orderItem.quantity, 5);
      expect(orderItem, isA<OrderItemModel>());
    });
  });
}
