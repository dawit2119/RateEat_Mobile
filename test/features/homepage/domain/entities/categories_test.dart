import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/menu.dart';

void main() {
  group('Categories Tests', () {
    late Categories categories;

    setUp(() {
      categories = Categories(
        id: '1',
        name: 'Appetizers',
        menu: Menu(
          id: 'menu1',
        ),
        menuId: 'menu1',
      );
    });

    test('should create a Categories instance', () {
      expect(categories.id, '1');
      expect(categories.name, 'Appetizers');
      expect(categories.menuId, 'menu1');
    });

    test('should convert Categories to Map', () {
      final map = categories.toMap();

      expect(map['id'], categories.id);
      expect(map['name'], categories.name);
      expect(map['menu'], categories.menu?.toMap());
    });

    test('should create Categories from Map', () {
      final map = {
        'id': '2',
        'name': 'Desserts',
        'menu': {
          'id': 'menu2',
        },
      };

      final newCategories = Categories.fromMap(map);

      expect(newCategories.id, '2');
      expect(newCategories.name, 'Desserts');
    });

    test('should handle null values when creating from Map', () {
      final map = {
        'id': null,
        'name': null,
        'menu': null,
      };

      final newCategories = Categories.fromMap(map);

      expect(newCategories.id, null);
      expect(newCategories.name, null);
      expect(newCategories.menu, null);
    });

    test('should convert Categories to JSON', () {
      final json = categories.toJson();

      expect(json, isA<String>());
      expect(json, contains('"id":"1"'));
      expect(json, contains('"name":"Appetizers"'));
    });

    test('should create Categories from JSON', () {
      final json = '''
      {
        "id": "3",
        "name": "Beverages",
        "menu": {"id": "menu3"}
      }
      ''';

      final newCategories = Categories.fromJson(json);

      expect(newCategories.id, '3');
      expect(newCategories.name, 'Beverages');
    });

    test('copyWith should return a new Categories instance', () {
      final updatedCategories = categories.copyWith(name: 'Starters');

      expect(updatedCategories.id, categories.id);
      expect(updatedCategories.name, 'Starters');
      expect(updatedCategories.menu, categories.menu);
    });
  });
}
