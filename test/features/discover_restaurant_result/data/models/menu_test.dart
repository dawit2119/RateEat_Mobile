import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/menu.dart';

void main() {
  group('Menu', () {
    test('should create an instance with given properties', () {
      const menu = Menu(id: '1');

      expect(menu.id, '1');
    });

    test('fromJson should create an instance from JSON', () {
      final jsonData = {
        'id': '1',
      };

      final menu = MenuModel.fromJson(jsonData);

      expect(menu.id, '1');
    });

    test('copyWith should create a new instance with updated values', () {
      const menu = MenuModel(id: '1', items: [], totalItemsCount: 1);

      final updatedMenu = menu.copyWith(id: '2');
      final updatedWithNull = menu.copyWith();

      expect(updatedMenu.id, '2');
      expect(updatedWithNull.id, '1');
    });

    test('equality operator should work correctly', () {
      const menu1 = Menu(id: '1');
      const menu2 = Menu(id: '1');
      const menu3 = Menu(id: '2');

      expect(menu1, menu2);
      expect(menu1, isNot(menu3));
    });
  });
}
