import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_location.dart';

void main() {
  group('RestaurantLocation', () {
    test('should create an instance with given properties', () {
      const restaurantLocation = RestaurantLocation(
        id: '1',
        latitude: 40.7128,
        longitude: -74.0060,
        description: 'New York City',
      );

      expect(restaurantLocation.id, '1');
      expect(restaurantLocation.latitude, 40.7128);
      expect(restaurantLocation.longitude, -74.0060);
      expect(restaurantLocation.description, 'New York City');
    });

    test('fromJson should create an instance from JSON', () {
      final jsonData = {
        'id': '1',
        'latitude': 40.7128,
        'longitude': -74.0060,
        'description': 'New York City',
      };

      final restaurantLocation = RestaurantLocation.fromJson(jsonData);

      expect(restaurantLocation.id, '1');
      expect(restaurantLocation.latitude, 40.7128);
      expect(restaurantLocation.longitude, -74.0060);
      expect(restaurantLocation.description, 'New York City');
    });

    test('copyWith should create a new instance with updated values', () {
      const restaurantLocation = RestaurantLocation(
        id: '1',
        latitude: 40.7128,
        longitude: -74.0060,
        description: 'New York City',
      );

      final updatedLocation = restaurantLocation.copyWith(
        description: 'Los Angeles',
      );

      expect(updatedLocation.id, '1');
      expect(updatedLocation.latitude, 40.7128);
      expect(updatedLocation.longitude, -74.0060);
      expect(updatedLocation.description, 'Los Angeles');
    });

    test('equality operator should work correctly', () {
      const location1 = RestaurantLocation(
        id: '1',
        latitude: 40.7128,
        longitude: -74.0060,
        description: 'New York City',
      );
      const location2 = RestaurantLocation(
        id: '1',
        latitude: 40.7128,
        longitude: -74.0060,
        description: 'New York City',
      );
      const location3 = RestaurantLocation(
        id: '2',
        latitude: 34.0522,
        longitude: -118.2437,
        description: 'Los Angeles',
      );

      expect(location1, location2); // They should be equal
      expect(location1, isNot(location3)); // They should not be equal
    });
  });
}
