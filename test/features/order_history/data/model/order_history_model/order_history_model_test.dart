import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order_history/data/models/order_history_model/order_history.dart';

void main() {
  final mockOrderHistoryJson = {
    'id': '123',
    'user_id': 'user_456',
    'restaurant_id': 'rest_789',
    'order_status': 'completed',
    'order_type': 'dine-in',
    'total_price': 1500,
    'total_number_of_items': 3,
    'estimated_waiting_time': 30,
    'order_message': 'Please add extra napkins.',
    'createdAt': '2024-02-18T12:00:00.000Z',
    'updatedAt': '2024-02-18T12:30:00.000Z',
    'order_items': [
      {
        'id': 'item_1',
        'item_id': 'Pizza',
        'quantity': 2,
        'item': {
          'name': 'pizza',
          'price': 200,
          'image_url':
              'https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg',
        },
      },
      {
        'id': 'item_2',
        'item_id': 'Pasta',
        'quantity': 1,
        'item': {
          'name': 'pizza',
          'price': 200,
          'image_url':
              'https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg',
        },
      }
    ],
  };

  group('OrderHistoryModel', () {
    test('fromMap should correctly convert JSON to model', () {
      final orderHistory = OrderHistoryModel.fromMap(mockOrderHistoryJson);

      expect(orderHistory.id, '123');
      expect(orderHistory.userId, 'user_456');
      expect(orderHistory.restaurantId, 'rest_789');
      expect(orderHistory.orderStatus, 'completed');
      expect(orderHistory.orderType, 'dine-in');
      expect(orderHistory.totalPrice, 1500);
      expect(orderHistory.totalNumberOfItems, 3);
      expect(orderHistory.estimatedWaitingTime, 30);
      expect(orderHistory.orderMessage, 'Please add extra napkins.');
      expect(
          orderHistory.createdAt, DateTime.parse('2024-02-18T12:00:00.000Z'));
      expect(
          orderHistory.updatedAt, DateTime.parse('2024-02-18T12:30:00.000Z'));
      expect(orderHistory.orderItems, isNotNull);
      expect(orderHistory.orderItems!.length, 2);
    });

    test('toMap should correctly convert model to JSON', () {
      final orderHistory = OrderHistoryModel.fromMap(mockOrderHistoryJson);
      final map = orderHistory.toMap();

      expect(map, mockOrderHistoryJson);
    });

    test('copyWith should correctly create a modified copy', () {
      final original = OrderHistoryModel.fromMap(mockOrderHistoryJson);
      final modified = original.copyWith(totalPrice: 2000);

      expect(modified.totalPrice, 2000);
      expect(modified.id, original.id); // Other properties remain unchanged
    });

    test('props should contain all properties for equality comparison', () {
      final order1 = OrderHistoryModel.fromMap(mockOrderHistoryJson);
      final order2 = OrderHistoryModel.fromMap(mockOrderHistoryJson);

      expect(order1, equals(order2)); // Ensures equality check works correctly
    });
  });
}
