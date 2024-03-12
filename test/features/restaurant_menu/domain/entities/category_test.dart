import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/category.dart';
import 'package:rateeat_mobile/src/features/homepage/data/models/item_model.dart';

void main() {
  group('CategoryEntity', () {
    test('props should return the correct values', () {
      final category = CategoryEntity(
        id: '123',
        name: 'Desserts',
        items: [
          ItemModel(itemName: 'Cake', itemId: '1', numberOfReviews: 0),
          ItemModel(itemName: 'Ice Cream', itemId: '2', numberOfReviews: 0),
        ],
      );

      expect(category.props, [
        '123',
        'Desserts',
        [
          ItemModel(itemName: 'Cake', itemId: '1', numberOfReviews: 0),
          ItemModel(itemName: 'Ice Cream', itemId: '2', numberOfReviews: 0),
        ],
      ]);
    });

    test('props should handle null id and name', () {
      final category = CategoryEntity(
        items: [
          ItemModel(itemName: 'Pizza', itemId: '3', numberOfReviews: 0),
        ],
      );

      expect(
        category.props,
        [
          '',
          '',
          [ItemModel(itemName: 'Pizza', itemId: '3', numberOfReviews: 0)],
        ],
      );
    });

    test('two CategoryEntity objects with the same properties should be equal',
        () {
      final category1 = CategoryEntity(
        id: '456',
        name: 'Main Courses',
        items: [ItemModel(itemName: 'Steak', itemId: '4', numberOfReviews: 0)],
      );

      final category2 = CategoryEntity(
        id: '456',
        name: 'Main Courses',
        items: [ItemModel(itemName: 'Steak', itemId: '4', numberOfReviews: 0)],
      );

      expect(category1, equals(category2));
    });

    test(
        'two CategoryEntity objects with different properties should not be equal',
        () {
      final category1 = CategoryEntity(
        id: '789',
        name: 'Appetizers',
        items: [ItemModel(itemName: 'Salad', itemId: '5', numberOfReviews: 0)],
      );

      final category2 = CategoryEntity(
        id: '101',
        name: 'Appetizers',
        items: [ItemModel(itemName: 'Soup', itemId: '6', numberOfReviews: 0)],
      );

      expect(category1, isNot(equals(category2)));
    });

    test('CategoryEntity with no items should have empty item list', () {
      final category = CategoryEntity(id: "1", name: "drinks");
      expect(category.items, equals([]));
    });
  });
}
