import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/restaurant_category.dart';

void main() {
  group('RestaurantCategory', () {
    test('props should return the correct values', () {
      final category = RestaurantCategory(
        id: '123',
        name: 'Appetizers',
        menuId: '456',
        isApproved: true,
      );

      expect(category.props, ['123', 'Appetizers', '456', true]);
    });

    test(
        'two RestaurantCategory objects with the same properties should be equal',
        () {
      final category1 = RestaurantCategory(
        id: '123',
        name: 'Appetizers',
        menuId: '456',
        isApproved: true,
      );

      final category2 = RestaurantCategory(
        id: '123',
        name: 'Appetizers',
        menuId: '456',
        isApproved: true,
      );

      expect(category1, equals(category2));
    });

    test(
        'two RestaurantCategory objects with different properties should not be equal',
        () {
      final category1 = RestaurantCategory(
        id: '123',
        name: 'Appetizers',
        menuId: '456',
        isApproved: true,
      );

      final category2 = RestaurantCategory(
        id: '789',
        name: 'Main Courses',
        menuId: '101',
        isApproved: false,
      );

      expect(category1, isNot(equals(category2)));
    });

    test(
        'RestaurantCategory with isApproved false should be different from true',
        () {
      final category1 = RestaurantCategory(
        id: '1',
        name: 'Desserts',
        menuId: '2',
        isApproved: false,
      );

      final category2 = RestaurantCategory(
        id: '1',
        name: 'Desserts',
        menuId: '2',
        isApproved: true,
      );

      expect(category1, isNot(equals(category2)));
    });

    test('RestaurantCategory with different menuId should be different', () {
      final category1 = RestaurantCategory(
        id: '1',
        name: 'Desserts',
        menuId: '2',
        isApproved: true,
      );

      final category2 = RestaurantCategory(
        id: '1',
        name: 'Desserts',
        menuId: '3',
        isApproved: true,
      );

      expect(category1, isNot(equals(category2)));
    });

    test('RestaurantCategory with different name should be different', () {
      final category1 = RestaurantCategory(
        id: '1',
        name: 'Desserts',
        menuId: '2',
        isApproved: true,
      );

      final category2 = RestaurantCategory(
        id: '1',
        name: 'Drinks',
        menuId: '2',
        isApproved: true,
      );

      expect(category1, isNot(equals(category2)));
    });

    test('RestaurantCategory with different id should be different', () {
      final category1 = RestaurantCategory(
        id: '1',
        name: 'Desserts',
        menuId: '2',
        isApproved: true,
      );

      final category2 = RestaurantCategory(
        id: '3',
        name: 'Desserts',
        menuId: '2',
        isApproved: true,
      );

      expect(category1, isNot(equals(category2)));
    });
  });
}
