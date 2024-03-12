import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('RecommendedRestaurantLocationEntity Tests', () {
    late RecommendedRestaurantLocationEntity location;

    setUp(() {
      location = RecommendedRestaurantLocationEntity(
        id: 'loc1',
        latitude: 37.7749,
        longitude: -122.4194,
        description: 'Near the Golden Gate Bridge',
      );
    });

    test('should create a RecommendedRestaurantLocationEntity instance', () {
      expect(location.id, 'loc1');
      expect(location.latitude, 37.7749);
      expect(location.longitude, -122.4194);
      expect(location.description, 'Near the Golden Gate Bridge');
    });

    test('should be equal when all properties are the same', () {
      final anotherLocation = RecommendedRestaurantLocationEntity(
        id: 'loc1',
        latitude: 37.7749,
        longitude: -122.4194,
        description: 'Near the Golden Gate Bridge',
      );

      expect(location, anotherLocation);
    });

    test('should not be equal when id is different', () {
      final differentLocation = RecommendedRestaurantLocationEntity(
        id: 'loc2',
        latitude: 37.7749,
        longitude: -122.4194,
        description: 'Near the Golden Gate Bridge',
      );

      expect(location, isNot(equals(differentLocation)));
    });

    test('should handle nullable properties correctly', () {
      final locationWithNulls = RecommendedRestaurantLocationEntity(
        id: null,
        latitude: null,
        longitude: null,
        description: null,
      );

      expect(locationWithNulls.id, null);
      expect(locationWithNulls.latitude, null);
      expect(locationWithNulls.longitude, null);
      expect(locationWithNulls.description, null);
    });
  });
}
