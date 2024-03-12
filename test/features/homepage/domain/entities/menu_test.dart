import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/menu.dart';

void main() {
  group('Restaurant Tests', () {
    late Restaurant restaurant;

    setUp(() {
      restaurant = Restaurant(
        id: 'rest1',
        name: 'Pizza Place',
        currencyCode: 'USD',
      );
    });

    test('should create a Restaurant instance', () {
      expect(restaurant.id, 'rest1');
      expect(restaurant.name, 'Pizza Place');
      expect(restaurant.currencyCode, 'USD');
    });

    test('should convert Restaurant to Map', () {
      final map = restaurant.toMap();

      expect(map['id'], restaurant.id);
      expect(map['name'], restaurant.name);
      expect(map['currency'], restaurant.currencyCode);
    });

    test('should create Restaurant from Map', () {
      final map = {
        'id': 'rest2',
        'name': 'Burger Joint',
        'currency': 'USD',
      };

      final newRestaurant = Restaurant.fromMap(map);

      expect(newRestaurant.id, 'rest2');
      expect(newRestaurant.name, 'Burger Joint');
      expect(newRestaurant.currencyCode, 'USD');
    });

    test('should convert Restaurant to JSON', () {
      final json = restaurant.toJson();

      expect(json, isA<String>());
      expect(json, contains('"id":"rest1"'));
      expect(json, contains('"name":"Pizza Place"'));
    });

    test('should create Restaurant from JSON', () {
      final json = '''
      {
        "id": "rest3",
        "name": "Sushi Spot",
        "currency": "JPY"
      }
      ''';

      final newRestaurant = Restaurant.fromJson(json);

      expect(newRestaurant.id, 'rest3');
      expect(newRestaurant.name, 'Sushi Spot');
      expect(newRestaurant.currencyCode, 'JPY');
    });
  });

  group('Menu Tests', () {
    late Menu menu;

    setUp(() {
      menu = Menu(
        id: 'menu1',
        restaurant: Restaurant(id: 'rest1', name: 'Pizza Place'),
      );
    });

    test('should create a Menu instance', () {
      expect(menu.id, 'menu1');
      expect(menu.restaurant?.name, 'Pizza Place');
    });

    test('should convert Menu to Map', () {
      final map = menu.toMap();

      expect(map['id'], menu.id);
      expect(map['restaurant']?['name'], menu.restaurant?.name);
    });

    test('should create Menu from Map', () {
      final map = {
        'id': 'menu2',
        'restaurant': {
          'id': 'rest2',
          'name': 'Burger Joint',
        },
      };

      final newMenu = Menu.fromMap(map);

      expect(newMenu.id, 'menu2');
      expect(newMenu.restaurant?.name, 'Burger Joint');
    });

    test('should convert Menu to JSON', () {
      final json = menu.toJson();

      expect(json, isA<String>());
      expect(json, contains('"id":"menu1"'));
      expect(json, contains('"restaurant":{"id":"rest1","name":"Pizza Place"'));
    });

    test('should create Menu from JSON', () {
      final json = '''
      {
        "id": "menu3",
        "restaurant": {
          "id": "rest3",
          "name": "Taco Stand"
        }
      }
      ''';

      final newMenu = Menu.fromJson(json);

      expect(newMenu.id, 'menu3');
      expect(newMenu.restaurant?.name, 'Taco Stand');
    });
  });
}
