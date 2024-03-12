import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/data/models/models.dart';

void main() {
  group('OrderStatusModel', () {
    test('fromMap should correctly parse map data into an OrderStatusModel',
        () {
      // Arrange: Sample data similar to what might be used in the application
      final mapData = {
        "id": "12345",
        "time": "2024-10-29T08:16:11.506Z",
        "title": "Order Placed",
        "isCompleted": true,
        "isCurrent": false,
      };

      // Act: Parse the map into an OrderStatusModel
      final orderStatus = OrderStatusModel.fromMap(mapData);

      // Assert: Verify each field is correctly populated
      expect(orderStatus, isA<OrderStatusModel>());
      expect(orderStatus.orderId, "12345");
      expect(orderStatus.time, "2024-10-29T08:16:11.506Z");
      expect(orderStatus.title, "Order Placed");
      expect(orderStatus.isCompleted, true);
      expect(orderStatus.isCurrent, false);
    });

    test('OrderStatusModel properties should hold the expected values', () {
      // Arrange: Create an instance of OrderStatusModel
      final orderStatus = OrderStatusModel(
        orderId: "67890",
        time: "2024-10-29T09:00:00.000Z",
        title: "Order Delivered",
        isCompleted: false,
        isCurrent: true,
      );

      // Assert: Verify that the properties match the initialized values
      expect(orderStatus.orderId, "67890");
      expect(orderStatus.time, "2024-10-29T09:00:00.000Z");
      expect(orderStatus.title, "Order Delivered");
      expect(orderStatus.isCompleted, false);
      expect(orderStatus.isCurrent, true);
    });
  });
}
