import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu.dart';
import "package:rateeat_mobile/src/features/homepage/domain/entities/item.dart";

void main() {
  group('Menu', () {
    test('props should return the correct values', () {
      final menu = Menu(
        id: '123',
        items: [
          Item(itemId: 'item1', itemName: 'Item 1', numberOfReviews: 0),
          Item(itemId: 'item2', itemName: 'Item 2', numberOfReviews: 0),
        ],
        totalItemsCount: 2,
      );

      expect(menu.props, [
        '123',
        [
          Item(itemId: 'item1', itemName: 'Item 1', numberOfReviews: 0),
          Item(itemId: 'item2', itemName: 'Item 2', numberOfReviews: 0),
        ],
      ]);
    });

    test('loadedItemsCount should default to 0', () {
      final menu = Menu(
        id: '456',
        items: [Item(itemId: 'item3', itemName: 'Item 3', numberOfReviews: 0)],
        totalItemsCount: 1,
      );

      expect(menu.loadedItemsCount, 0);
    });

    test('two Menu objects with the same properties should be equal', () {
      final menu1 = Menu(
        id: '789',
        items: [Item(itemId: 'item4', itemName: 'Item 4', numberOfReviews: 0)],
        totalItemsCount: 1,
        loadedItemsCount: 1,
      );

      final menu2 = Menu(
        id: '789',
        items: [Item(itemId: 'item4', itemName: 'Item 4', numberOfReviews: 0)],
        totalItemsCount: 1,
        loadedItemsCount: 1,
      );

      expect(menu1, equals(menu2));
    });

    test('two Menu objects with different properties should not be equal', () {
      final menu1 = Menu(
        id: '101',
        items: [Item(itemId: 'item5', itemName: 'Item 5', numberOfReviews: 0)],
        totalItemsCount: 1,
      );

      final menu2 = Menu(
        id: '102',
        items: [Item(itemId: 'item5', itemName: 'Item 5', numberOfReviews: 0)],
        totalItemsCount: 1,
      );

      expect(menu1, isNot(equals(menu2)));
    });

    test('two Menu objects with different item lists should not be equal', () {
      final menu1 = Menu(
          id: "1",
          items: [Item(itemId: "1", itemName: "item1", numberOfReviews: 0)],
          totalItemsCount: 1);
      final menu2 = Menu(
          id: "1",
          items: [Item(itemId: "2", itemName: "item2", numberOfReviews: 0)],
          totalItemsCount: 1);

      expect(menu1, isNot(equals(menu2)));
    });

    test('loadedItemsCount can be set', () {
      final menu =
          Menu(id: "1", items: [], totalItemsCount: 0, loadedItemsCount: 5);
      expect(menu.loadedItemsCount, 5);
    });
  });
}
