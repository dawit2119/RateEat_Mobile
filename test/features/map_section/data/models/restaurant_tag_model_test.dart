import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/map_section/data/models/restaurant_tag_model.dart';

void main() {
  group('RestaurantTagModel Tests', () {
    test('fromMap creates RestaurantTagModel from Map', () {
      // Arrange
      final data = {
        'id': '1',
        'name': 'Vegan',
      };

      // Act
      final tag = RestaurantTagModel.fromMap(data);

      // Assert
      expect(tag.id, '1');
      expect(tag.name, 'Vegan');
    });

    test('toMap converts RestaurantTagModel to Map', () {
      // Arrange
      final tag = RestaurantTagModel(
        id: '1',
        name: 'Vegan',
      );

      // Act
      final map = tag.toMap();

      // Assert
      expect(map['id'], '1');
      expect(map['name'], 'Vegan');
    });

    test('fromJson creates RestaurantTagModel from JSON', () {
      // Arrange
      final jsonString = json.encode({
        'id': '1',
        'name': 'Vegan',
      });

      // Act
      final tag = RestaurantTagModel.fromJson(jsonString);

      // Assert
      expect(tag.id, '1');
      expect(tag.name, 'Vegan');
    });

    test('toJson converts RestaurantTagModel to JSON string', () {
      // Arrange
      final tag = RestaurantTagModel(
        id: '1',
        name: 'Vegan',
      );

      // Act
      final jsonString = tag.toJson();

      // Assert
      expect(json.decode(jsonString)['id'], '1');
      expect(json.decode(jsonString)['name'], 'Vegan');
    });

    test('copyWith returns a new instance with updated values', () {
      // Arrange
      final tag = RestaurantTagModel(
        id: '1',
        name: 'Vegan',
      );

      // Act
      final updatedTag = tag.copyWith(name: 'Vegetarian');

      // Assert
      expect(updatedTag.id, '1');
      expect(updatedTag.name, 'Vegetarian');
    });
  });
}
