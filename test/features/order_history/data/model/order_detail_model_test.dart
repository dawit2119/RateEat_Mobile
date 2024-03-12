import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order_history/data/models/order_detail_model.dart';

void main() {
  group('OrderDetailModel.fromJson', () {
    test('should correctly parse valid JSON data', () {
      final Map<String, dynamic> testData = {
        "id": "order123",
        "restaurant_id": "rest456",
        "restaurant_name": "Test Restaurant",
        "order_status": "pending",
        "order_type": "delivery",
        "total_price": 29,
        "total_number_of_items": 3,
        "estimated_waiting_time": 45,
        "order_message": "Leave at the door",
        "createdAt": "2024-02-15T10:00:00Z",
        "updatedAt": "2024-02-15T11:00:00Z",
        "order_items": [
          {
            "id": "item789",
            "item_id": "item001",
            "quantity": 2,
            "item": {
              "name": "Pizza",
              "price": 10,
              "item_images": [
                {"url": "https://example.com/pizza.jpg"}
              ]
            }
          }
        ],
        "order_confirmed_at": null,
        "payment_confirmed_at": "2024-02-15T10:30:00Z",
        "order_placed_at": "2024-02-15T10:05:00Z",
        "order_completed_at": null,
        "order_rejected_at": null,
        "order_cancelled_at": null,
      };

      final orderDetail = OrderDetailModel.fromJson(testData);

      expect(orderDetail.id, "order123");
      expect(orderDetail.restaurantId, "rest456");
      expect(orderDetail.restaurantName, "Test Restaurant");
      expect(orderDetail.totalPrice, 29);
      expect(orderDetail.totalNumberOfItems, 3);
      expect(orderDetail.estimatedWaitingTime, 45);
      expect(orderDetail.orderMessage, "Leave at the door");
      expect(orderDetail.createdAt, DateTime.parse("2024-02-15T10:00:00Z"));
      expect(orderDetail.updatedAt, DateTime.parse("2024-02-15T11:00:00Z"));
      expect(orderDetail.orderItems.length, 1);
      expect(orderDetail.orderItems[0].item.name, "Pizza");
      expect(orderDetail.orderItems[0].item.itemImages[0].url,
          "https://example.com/pizza.jpg");
      expect(orderDetail.orderPlacedAt, DateTime.parse("2024-02-15T10:05:00Z"));
      expect(orderDetail.paymentConfirmedAt,
          DateTime.parse("2024-02-15T10:30:00Z"));
      expect(orderDetail.orderConfirmedAt, isNull);
      expect(orderDetail.orderCompletedAt, isNull);
    });

    test('should handle missing order_items gracefully', () {
      final Map<String, dynamic> testData = {
        "id": "order123",
        "restaurant_id": "rest456",
        "restaurant_name": "Test Restaurant",
        "order_status": "pending",
        "order_type": "delivery",
        "total_price": 29,
        "total_number_of_items": 3,
        "estimated_waiting_time": 45,
        "order_message": "Leave at the door",
        "createdAt": "2024-02-15T10:00:00Z",
        "updatedAt": "2024-02-15T11:00:00Z",
        "order_items": [],
      };

      final orderDetail = OrderDetailModel.fromJson(testData);

      expect(orderDetail.orderItems, isEmpty);
    });
  });
}
