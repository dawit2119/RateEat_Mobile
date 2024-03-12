import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

void main() {
  group('OrderModel', () {
    test('fromJson should correctly parse JSON into an OrderModel', () {
      // Arrange: Sample JSON data similar to what might be received from the server
      final json = {
        "id": "41c3a70f-1fe4-4160-abae-0489d4cc5e3d",
        "restaurant_id": "173bb17a-6994-4593-9d01-6004754ac183",
        "restaurant_name": "Amrogn Chicken | Piyassa",
        "order_status": "Order Created",
        "order_type": "DineIn",
        "total_price": 1425.50,
        "total_number_of_items": 5,
        "estimated_waiting_time": 30,
        "order_message": "Please pack the items carefully",
        "createdAt": "2024-10-29T08:16:11.506Z",
        "updatedAt": "2024-10-29T08:16:11.506Z",
        "order_items": [
          {"item_id": "642aa73f-070c-4d1f-81b6-74c74e8883ab", "quantity": 5}
        ],
        "order_confirmed_at": null,
        "payment_confirmed_at": null,
        "order_placed_at": null,
        "order_completed_at": null,
        "order_rejected_at": null,
        "order_cancelled_at": null,
      };

      // Act: Parse the JSON into an OrderModel
      final orderModel = OrderModel.fromJson(json);

      // Assert: Verify that fields are parsed correctly
      expect(orderModel, isA<OrderModel>());
      expect(orderModel.id, "41c3a70f-1fe4-4160-abae-0489d4cc5e3d");
      expect(orderModel.restaurantId, "173bb17a-6994-4593-9d01-6004754ac183");
      expect(orderModel.restaurantName, "Amrogn Chicken | Piyassa");
      expect(orderModel.orderStatus, "Order Created");
      expect(orderModel.orderType, "DineIn");
      expect(orderModel.totalPrice, 1425.50);
      expect(orderModel.totalNumberOfItems, 5);
      expect(orderModel.estimatedWaitingTime, 30);
      expect(orderModel.orderMessage, "Please pack the items carefully");
      expect(orderModel.createdAt, DateTime.parse("2024-10-29T08:16:11.506Z"));
      expect(orderModel.updatedAt, DateTime.parse("2024-10-29T08:16:11.506Z"));
      expect(orderModel.orderItems.length, 1);
      expect(orderModel.orderItems.first.itemId,
          "642aa73f-070c-4d1f-81b6-74c74e8883ab");
      expect(orderModel.orderItems.first.quantity, 5);
      expect(orderModel.orderConfirmedAt, isNull);
      expect(orderModel.paymentConfirmedAt, isNull);
      expect(orderModel.orderPlacedAt, isNull);
      expect(orderModel.orderCompletedAt, isNull);
      expect(orderModel.orderRejectedAt, isNull);
      expect(orderModel.orderCanceledAt, isNull);
    });

    test('toJson should correctly convert an OrderModel to JSON', () {
      // Arrange: Create an OrderModel instance
      final orderModel = OrderModel(
        id: "41c3a70f-1fe4-4160-abae-0489d4cc5e3d",
        restaurantId: "173bb17a-6994-4593-9d01-6004754ac183",
        restaurantName: "Amrogn Chicken | Piyassa",
        orderStatus: "Order Created",
        orderType: "DineIn",
        totalPrice: 1425.50,
        totalNumberOfItems: 5,
        estimatedWaitingTime: 30,
        orderMessage: "Please pack the items carefully",
        createdAt: DateTime.parse("2024-10-29T08:16:11.506Z"),
        updatedAt: DateTime.parse("2024-10-29T08:16:11.506Z"),
        orderItems: const [
          OrderItemModel(
              itemId: "642aa73f-070c-4d1f-81b6-74c74e8883ab", quantity: 5)
        ],
        orderConfirmedAt: null,
        paymentConfirmedAt: null,
        orderPlacedAt: null,
        orderCompletedAt: null,
        orderRejectedAt: null,
        orderCanceledAt: null,
      );

      // Act: Convert the OrderModel instance to JSON
      final json = orderModel.toJson();

      // Assert: Verify that the JSON output matches the expected structure
      expect(json, isA<Map<String, dynamic>>());
      expect(json['orderType'], "DineIn");
      expect(json['totalNumberOfItems'], 5);
      expect(json['totalPrice'], 1425.50);
      expect(json['estimatedWaitingTime'], 30);
      expect(json['orderMessage'], "Please pack the items carefully");
      expect(json['restaurantId'], "173bb17a-6994-4593-9d01-6004754ac183");
      expect(json['items'].length, 1);
      expect(
          json['items'][0]['itemId'], "642aa73f-070c-4d1f-81b6-74c74e8883ab");
      expect(json['items'][0]['quantity'], 5);
      expect(json['createdAt'], "2024-10-29 08:16:11.506Z");
      expect(json['updatedAt'], "2024-10-29 08:16:11.506Z");
    });
  });
}
