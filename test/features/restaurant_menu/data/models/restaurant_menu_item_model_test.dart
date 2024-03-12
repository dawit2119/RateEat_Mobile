import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/restaurant_menu_item.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu_item.dart';

void main() {
  group('RestaurantMenuItemModel', () {
    final testJson = {
      'id': '1',
      'name': 'Burger',
      'description': 'Delicious burger',
      'imageUrl': 'https://example.com/burger.jpg',
      'numberOfReviews': 100,
      'averageRating': 4.5,
      'price': 9.99,
    };

    test('should create a valid model from JSON', () {
      // Arrange & Act
      final model = RestaurantMenuItemModel.fromJson(testJson);

      // Assert
      expect(model.id, '1');
      expect(model.name, 'Burger');
      expect(model.description, 'Delicious burger');
      expect(model.imageUrl, 'https://example.com/burger.jpg');
      expect(model.numberOfReviews, 100);
      expect(model.averageRating, 4.5);
      expect(model.price, 9.99);
    });

    test('should create a JSON map from a model', () {
      // Arrange
      final model = RestaurantMenuItemModel(
        id: '1',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'https://example.com/burger.jpg',
        numberOfReviews: 100,
        averageRating: 4.5,
        price: 9.99,
      );

      // Act
      final resultJson = model.toJson();

      // Assert
      expect(resultJson, testJson);
    });

    test('should handle null values in JSON', () {
      // Arrange
      final nullJson = {
        'id': null,
        'name': null,
        'description': null,
        'imageUrl': null,
        'numberOfReviews': null,
        'averageRating': null,
        'price': null,
      };

      // Act
      final model = RestaurantMenuItemModel.fromJson(nullJson);

      // Assert
      expect(model.id, isNull);
      expect(model.name, isNull);
      expect(model.description, isNull);
      expect(model.imageUrl, isNull);
      expect(model.numberOfReviews, isNull);
      expect(model.averageRating, isNull);
      expect(model.price, isNull);
    });

    test('should create a valid model with constructor', () {
      // Arrange & Act
      final model = RestaurantMenuItemModel(
        id: '1',
        name: 'Pizza',
        description: 'Tasty pizza',
        imageUrl: 'https://example.com/pizza.jpg',
        numberOfReviews: 50,
        averageRating: 4.2,
        price: 12.99,
      );

      // Assert
      expect(model.id, '1');
      expect(model.name, 'Pizza');
      expect(model.description, 'Tasty pizza');
      expect(model.imageUrl, 'https://example.com/pizza.jpg');
      expect(model.numberOfReviews, 50);
      expect(model.averageRating, 4.2);
      expect(model.price, 12.99);
    });

    test('should correctly extend RestaurantMenuItem', () {
      // Arrange & Act
      final model = RestaurantMenuItemModel(
        id: '1',
        name: 'Salad',
        description: 'Fresh salad',
        imageUrl: 'https://example.com/salad.jpg',
        numberOfReviews: 30,
        averageRating: 4.0,
        price: 7.99,
      );

      // Assert
      expect(model, isA<RestaurantMenuItem>());
    });

    test('should handle partial JSON data', () {
      // Arrange
      final partialJson = {
        'id': '1',
        'name': 'Fries',
        'price': 3.99,
      };

      // Act
      final model = RestaurantMenuItemModel.fromJson(partialJson);

      // Assert
      expect(model.id, '1');
      expect(model.name, 'Fries');
      expect(model.price, 3.99);
      expect(model.description, isNull);
      expect(model.imageUrl, isNull);
      expect(model.numberOfReviews, isNull);
      expect(model.averageRating, isNull);
    });
  });
}
