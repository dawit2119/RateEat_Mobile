import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

void main() {
  group('OrderHistory', () {
    final orderItem1 = OrderItem(
      id: 'item_1',
      itemId: 'Burger',
      quantity: 2,
      item: ItemInfoEntity(
        name: 'Burger',
        price: 10,
        imageUrl: 'https://example.com/burger.jpg',
      ),
    );

    final orderItem2 = OrderItem(
      id: 'item_2',
      itemId: 'Fries',
      quantity: 1,
      item: ItemInfoEntity(
        name: 'Fries',
        price: 5,
        imageUrl: 'https://example.com/fries.jpg',
      ),
    );

    final orderHistory = OrderHistory(
      id: 'order_123',
      userId: 'user_456',
      restaurantId: 'restaurant_789',
      orderStatus: 'pending',
      orderType: 'delivery',
      totalPrice: 25,
      totalNumberOfItems: 3,
      estimatedWaitingTime: 30,
      orderMessage: 'Please make it spicy',
      createdAt: DateTime.parse('2024-02-18T12:00:00.000Z'),
      updatedAt: DateTime.parse('2024-02-18T12:30:00.000Z'),
      orderItems: [orderItem1, orderItem2],
    );

    test('toMap should return correct map', () {
      final expectedMap = {
        'id': 'order_123',
        'user_id': 'user_456',
        'restaurant_id': 'restaurant_789',
        'order_status': 'pending',
        'order_type': 'delivery',
        'total_price': 25,
        'total_number_of_items': 3,
        'estimated_waiting_time': 30,
        'order_message': 'Please make it spicy',
        'createdAt': '2024-02-18T12:00:00.000Z',
        'updatedAt': '2024-02-18T12:30:00.000Z',
        'order_items': [
          {
            'id': 'item_1',
            'item_id': 'Burger',
            'quantity': 2,
            'item': {
              'name': 'Burger',
              'price': 10,
              'image_url': 'https://example.com/burger.jpg',
            },
          },
          {
            'id': 'item_2',
            'item_id': 'Fries',
            'quantity': 1,
            'item': {
              'name': 'Fries',
              'price': 5,
              'image_url': 'https://example.com/fries.jpg',
            },
          },
        ],
      };

      expect(orderHistory.toMap(), expectedMap);
    });

    test('toJson should return correct JSON', () {
      final expectedJson =
          '{"id":"order_123","user_id":"user_456","restaurant_id":"restaurant_789","order_status":"pending","order_type":"delivery","total_price":25,"total_number_of_items":3,"estimated_waiting_time":30,"order_message":"Please make it spicy","createdAt":"2024-02-18T12:00:00.000Z","updatedAt":"2024-02-18T12:30:00.000Z","order_items":[{"id":"item_1","item_id":"Burger","quantity":2,"item":{"name":"Burger","price":10,"image_url":"https://example.com/burger.jpg"}},{"id":"item_2","item_id":"Fries","quantity":1,"item":{"name":"Fries","price":5,"image_url":"https://example.com/fries.jpg"}}]}';

      expect(orderHistory.toJson(), expectedJson);
    });

    test('should support value equality', () {
      final orderHistory1 = OrderHistory(
        id: 'order_123',
        userId: 'user_456',
        restaurantId: 'restaurant_789',
        orderStatus: 'pending',
        orderType: 'delivery',
        totalPrice: 25,
        totalNumberOfItems: 3,
        estimatedWaitingTime: 30,
        orderMessage: 'Please make it spicy',
        createdAt: DateTime.parse('2024-02-18T12:00:00.000Z'),
        updatedAt: DateTime.parse('2024-02-18T12:30:00.000Z'),
        orderItems: [orderItem1, orderItem2],
      );

      final orderHistory2 = OrderHistory(
        id: 'order_123',
        userId: 'user_456',
        restaurantId: 'restaurant_789',
        orderStatus: 'pending',
        orderType: 'delivery',
        totalPrice: 25,
        totalNumberOfItems: 3,
        estimatedWaitingTime: 30,
        orderMessage: 'Please make it spicy',
        createdAt: DateTime.parse('2024-02-18T12:00:00.000Z'),
        updatedAt: DateTime.parse('2024-02-18T12:30:00.000Z'),
        orderItems: [orderItem1, orderItem2],
      );

      expect(orderHistory1,
          equals(orderHistory2)); // Equatable ensures deep equality
    });

    test('should return correct props', () {
      expect(orderHistory.props, [
        'order_123',
        'user_456',
        'restaurant_789',
        'pending',
        'delivery',
        25,
        3,
        30,
        'Please make it spicy',
        DateTime.parse('2024-02-18T12:00:00.000Z'),
        DateTime.parse('2024-02-18T12:30:00.000Z'),
        [orderItem1, orderItem2],
      ]);
    });
  });
}
