import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('PriceRangeModel', () {
    test('should create a PriceRangeModel from valid map', () {
      // Given
      final map = {
        'min': 0,
        'max': 200,
        'count': 22,
      };

      // When
      final priceRange = PriceRangeModel.fromMap(map);

      // Then
      expect(priceRange.minPrice, 0);
      expect(priceRange.maxPrice, 200);
      expect(priceRange.count, 22);
    });

    test('should return null for max price when max is 9007199254740991', () {
      // Given
      final map = {
        'min': 500,
        'max': 9007199254740991, // Special case
        'count': 1,
      };

      // When
      final priceRange = PriceRangeModel.fromMap(map);

      // Then
      expect(priceRange.minPrice, 500);
      expect(priceRange.maxPrice, null); // Should be null in this case
      expect(priceRange.count, 1);
    });

    test('should create a PriceRangeModel with different values', () {
      // Given
      final map = {
        'min': 200,
        'max': 500,
        'count': 55,
      };

      // When
      final priceRange = PriceRangeModel.fromMap(map);

      // Then
      expect(priceRange.minPrice, 200);
      expect(priceRange.maxPrice, 500);
      expect(priceRange.count, 55);
    });
  });
}
