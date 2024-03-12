import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/entities/order_history/order_item.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/entities/order_history/item_info_entity.dart';

void main() {
  group('OrderItem', () {
    final itemInfo = ItemInfoEntity(
      name: 'Burger',
      price: 10,
      imageUrl: 'https://example.com/burger.jpg',
    );

    final orderItem = OrderItem(
      id: 'item_1',
      itemId: 'burger_123',
      quantity: 2,
      item: itemInfo,
    );

    test('toMap should return correct map', () {
      final expectedMap = {
        'id': 'item_1',
        'item_id': 'burger_123',
        'quantity': 2,
        'item': {
          'name': 'Burger',
          'price': 10,
          'image_url': 'https://example.com/burger.jpg',
        },
      };

      expect(orderItem.toMap(), expectedMap);
    });

    test('should support value equality', () {
      final orderItem2 = OrderItem(
        id: 'item_1',
        itemId: 'burger_123',
        quantity: 2,
        item: itemInfo,
      );

      expect(orderItem, equals(orderItem2)); // Equatable ensures deep equality
    });

    test('toMap should handle null values correctly', () {
      final orderItemWithNulls = OrderItem();

      final expectedMap = {
        'id': null,
        'item_id': null,
        'quantity': null,
        'item': null,
      };

      expect(orderItemWithNulls.toMap(), expectedMap);
    });
  });
}
