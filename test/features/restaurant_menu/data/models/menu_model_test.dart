import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/menu.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu.dart';

void main() {
  const menu = MenuModel(
    id: '1',
    items: [],
    totalItemsCount: 0,
    loadedItemsCount: 0,
  );

  group('Menu Model', () {
    test('should be a subclass of Menu', () async {
      expect(menu, isA<Menu>());
    });

    group('fromMap', () {
      test('should return a valid model from json', () async {
        final result = MenuModel.fromJson(const {
          "id": "1",
          "category": [],
        });
        expect(result, isA<MenuModel>());
      });
    });

    group('copyWith', () {
      test('should return a copy of the model', () async {
        final result = menu.copyWith(
          id: '1',
          items: [],
        );
        expect(result, menu);
      });
    });
  });
}
