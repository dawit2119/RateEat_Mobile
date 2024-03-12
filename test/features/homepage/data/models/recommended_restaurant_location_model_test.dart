import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('RecommendedRestaurantLocationModel Tests', () {
    late RecommendedRestaurantLocationModel locationModel;

    setUp(() {
      locationModel = RecommendedRestaurantLocationModel(
        id: '1',
        latitude: 37.7749,
        longitude: -122.4194,
        description: 'A popular restaurant in San Francisco.',
      );
    });

    test('should create a RecommendedRestaurantLocationModel instance', () {
      expect(locationModel.id, '1');
      expect(locationModel.latitude, 37.7749);
      expect(locationModel.longitude, -122.4194);
      expect(
          locationModel.description, 'A popular restaurant in San Francisco.');
    });

    test('should convert RecommendedRestaurantLocationModel to JSON', () {
      final json = locationModel.toJson();

      expect(json['id'], locationModel.id);
      expect(json['latitude'], locationModel.latitude);
      expect(json['longitude'], locationModel.longitude);
      expect(json['description'], locationModel.description);
    });

    test('should create RecommendedRestaurantLocationModel from JSON', () {
      final json = {
        'id': '2',
        'latitude': 34.0522,
        'longitude': -118.2437,
        'description': 'A famous restaurant in Los Angeles.',
      };

      final newLocation = RecommendedRestaurantLocationModel.fromJson(json);

      expect(newLocation.id, '2');
      expect(newLocation.latitude, 34.0522);
      expect(newLocation.longitude, -118.2437);
      expect(newLocation.description, 'A famous restaurant in Los Angeles.');
    });

    test('should handle null values when creating from JSON', () {
      final json = {
        'id': null,
        'latitude': null,
        'longitude': null,
        'description': null,
      };

      final newLocation = RecommendedRestaurantLocationModel.fromJson(json);

      expect(newLocation.id, '');
      expect(newLocation.latitude, null);
      expect(newLocation.longitude, null);
      expect(newLocation.description, '');
    });
  });
}
