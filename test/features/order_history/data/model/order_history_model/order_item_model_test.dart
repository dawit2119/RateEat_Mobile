import 'package:rateeat_mobile/src/features/order_history/data/models/order_history_model/order_item_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('OrderItemModel should parse from Map correctly', () {
    final Map<String, dynamic> testData = {
      'id': '123',
      'item_id': '456',
      'quantity': 2,
      'item': {
        'name': 'Pizza',
        'price': 10,
        'image_url': 'https://www.example.com/pizza.jpg',
      }
    };

    final orderItem = OrderItemModel.fromMap(testData);

    expect(orderItem.id, '123');
    expect(orderItem.itemId, '456');
    expect(orderItem.quantity, 2);
    expect(orderItem.item, isNotNull);
    expect(orderItem.item!.name, 'Pizza');
  });

  test('OrderItemModel should handle null values correctly', () {
    final Map<String, dynamic> testData = {
      'id': null,
      'item_id': null,
      'quantity': null,
      'item': null,
    };

    final orderItem = OrderItemModel.fromMap(testData);

    expect(orderItem.id, isNull);
    expect(orderItem.itemId, isNull);
    expect(orderItem.quantity, isNull);
    expect(orderItem.item, isNull);
  });
}
