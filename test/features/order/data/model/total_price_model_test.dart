import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/order/data/models/total_price_model.dart';

void main() {
  group('TotalPriceModel', () {
    test('fromMap should correctly create a TotalPriceModel from map', () {
      // Arrange: Create a sample map
      final totalPriceMap = {
        'totalItems': 3,
        'totalPrice': 150.75,
      };

      // Act: Create a TotalPriceModel instance using fromMap
      final totalPrice = TotalPriceModel.fromMap(totalPriceMap);

      // Assert: Verify that the instance properties match the map values
      expect(totalPrice.totalItems, 3);
      expect(totalPrice.totalPrice, 150.75);
    });

    test('TotalPriceModel properties should hold the expected values', () {
      // Arrange & Act: Create an instance of TotalPriceModel
      const totalPrice = TotalPriceModel(totalItems: 5, totalPrice: 200.0);

      // Assert: Verify that the properties match the initialized values
      expect(totalPrice.totalItems, 5);
      expect(totalPrice.totalPrice, 200.0);
    });

    test('fromMap should handle missing or null fields with default values',
        () {
      // Arrange: Map with missing or incorrect values
      final invalidTotalPriceMap = {
        'totalItems': null,
        'totalPrice': null,
      };

      // Act: Create a TotalPriceModel instance using fromMap and null-aware operators
      final totalPrice = TotalPriceModel(
        totalItems: invalidTotalPriceMap['totalItems'] ?? 0,
        totalPrice: invalidTotalPriceMap['totalPrice'] ?? 0.0,
      );

      // Assert: Verify that default values are used for missing fields
      expect(totalPrice.totalItems, 0);
      expect(totalPrice.totalPrice, 0.0);
    });
  });
}
