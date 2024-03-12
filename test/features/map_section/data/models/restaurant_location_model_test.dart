import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/map_section/data/models/restaurant_location_model.dart';

void main() {
  group('RestaurantLocationModel Tests', () {
    test('fromMap creates RestaurantLocationModel from Map', () {
      // Arrange
      final data = {
        'id': '1',
        'latitude': 12.34,
        'longitude': 56.78,
        'description': 'Test location',
      };

      // Act
      final location = RestaurantLocationModel.fromMap(data);

      // Assert
      expect(location.id, '1');
      expect(location.latitude, 12.34);
      expect(location.longitude, 56.78);
      expect(location.description, 'Test location');
    });

    test('toMap converts RestaurantLocationModel to Map', () {
      // Arrange
      final location = RestaurantLocationModel(
        id: '1',
        latitude: 12.34,
        longitude: 56.78,
        description: 'Test location',
      );

      // Act
      final map = location.toMap();

      // Assert
      expect(map['id'], '1');
      expect(map['latitude'], 12.34);
      expect(map['longitude'], 56.78);
      expect(map['description'], 'Test location');
    });

    test('fromJson creates RestaurantLocationModel from JSON', () {
      // Arrange
      final jsonString = json.encode({
        'id': '1',
        'latitude': 12.34,
        'longitude': 56.78,
        'description': 'Test location',
      });

      // Act
      final location = RestaurantLocationModel.fromJson(jsonString);

      // Assert
      expect(location.id, '1');
      expect(location.latitude, 12.34);
      expect(location.longitude, 56.78);
      expect(location.description, 'Test location');
    });

    test('toJson converts RestaurantLocationModel to JSON string', () {
      // Arrange
      final location = RestaurantLocationModel(
        id: '1',
        latitude: 12.34,
        longitude: 56.78,
        description: 'Test location',
      );

      // Act
      final jsonString = location.toJson();

      // Assert
      expect(json.decode(jsonString)['id'], '1');
      expect(json.decode(jsonString)['latitude'], 12.34);
      expect(json.decode(jsonString)['longitude'], 56.78);
      expect(json.decode(jsonString)['description'], 'Test location');
    });

    test('copyWith returns a new instance with updated values', () {
      // Arrange
      final location = RestaurantLocationModel(
        id: '1',
        latitude: 12.34,
        longitude: 56.78,
        description: 'Test location',
      );

      // Act
      final updatedLocation = location.copyWith(latitude: 15.0);

      // Assert
      expect(updatedLocation.id, '1');
      expect(updatedLocation.latitude, 15.0);
      expect(updatedLocation.longitude, 56.78);
      expect(updatedLocation.description, 'Test location');
    });
  });
}
