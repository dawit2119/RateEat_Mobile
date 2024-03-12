import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu_item.dart';

void main() {
  group('RestaurantMenuItem', () {
    test('props should return the correct values', () {
      final menuItem = RestaurantMenuItem(
        id: '123',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'burger.jpg',
        numberOfReviews: 100,
        averageRating: 4.5,
        price: 10.99,
      );

      expect(menuItem.props, [
        '123',
        'Burger',
        'Delicious burger',
        'burger.jpg',
        100,
        4.5,
        10.99,
      ]);
    });

    test('toJson should return the correct map', () {
      final menuItem = RestaurantMenuItem(
        id: '123',
        name: 'Burger',
        description: 'Delicious burger',
        imageUrl: 'burger.jpg',
        numberOfReviews: 100,
        averageRating: 4.5,
        price: 10.99,
      );

      final json = menuItem.toJson();

      expect(json, {
        'id': '123',
        'name': 'Burger',
        'description': 'Delicious burger',
        'imageUrl': 'burger.jpg',
        'numberOfReviews': 100,
        'averageRating': 4.5,
        'price': 10.99,
      });
    });

    test('fromJson should create a RestaurantMenuItem from a map', () {
      final json = {
        'id': '123',
        'name': 'Burger',
        'description': 'Delicious burger',
        'imageUrl': 'burger.jpg',
        'numberOfReviews': 100,
        'averageRating': 4.5,
        'price': 10.99,
      };

      final menuItem = RestaurantMenuItem.fromJson(json);

      expect(
          menuItem,
          RestaurantMenuItem(
            id: '123',
            name: 'Burger',
            description: 'Delicious burger',
            imageUrl: 'burger.jpg',
            numberOfReviews: 100,
            averageRating: 4.5,
            price: 10.99,
          ));
    });

    test(
        'two RestaurantMenuItem objects with the same properties should be equal',
        () {
      final menuItem1 = RestaurantMenuItem(id: '1', name: 'Pizza', price: 12.0);
      final menuItem2 = RestaurantMenuItem(id: '1', name: 'Pizza', price: 12.0);

      expect(menuItem1, equals(menuItem2));
    });

    test(
        'two RestaurantMenuItem objects with different properties should not be equal',
        () {
      final menuItem1 = RestaurantMenuItem(id: '1', name: 'Pizza', price: 12.0);
      final menuItem2 = RestaurantMenuItem(id: '2', name: 'Pizza', price: 12.0);

      expect(menuItem1, isNot(equals(menuItem2)));
    });

    test('fromJson should handle null values', () {
      final json = {
        'id': null,
        'name': null,
        'description': null,
        'imageUrl': null,
        'numberOfReviews': null,
        'averageRating': null,
        'price': null,
      };

      final menuItem = RestaurantMenuItem.fromJson(json);

      expect(
          menuItem,
          RestaurantMenuItem(
            id: null,
            name: null,
            description: null,
            imageUrl: null,
            numberOfReviews: null,
            averageRating: null,
            price: null,
          ));
    });
  });
}
