import 'package:test/test.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/filter_item.dart';

void main() {
  group('Ingredient Tests', () {
    test('Ingredient creation', () {
      final ingredient = Ingredient(id: 'ing1', name: 'Salt');
      expect(ingredient.id, 'ing1');
      expect(ingredient.name, 'Salt');
    });

    test('Ingredient fromJson', () {
      final json = {'id': 'ing1', 'name': 'Salt'};
      final ingredient = Ingredient.fromJson(json);
      expect(ingredient.id, 'ing1');
      expect(ingredient.name, 'Salt');
    });
  });

  group('Menu Tests', () {
    test('Menu creation', () {
      final restaurant = Ingredient(id: 'rest1', name: 'Restaurant A');
      final menu = Menu(
        id: 'menu1',
        restaurantId: 'rest1',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
        restaurant: restaurant,
      );
      expect(menu.id, 'menu1');
      expect(menu.restaurantId, 'rest1');
      expect(menu.createdAt, DateTime(2023, 1, 1));
      expect(menu.restaurant.name, 'Restaurant A');
    });

    test('Menu fromJson', () {
      final json = {
        'id': 'menu1',
        'restaurant_id': 'rest1',
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-02T00:00:00.000Z',
        'restaurant': {'id': 'rest1', 'name': 'Restaurant A'}
      };
      final menu = Menu.fromJson(json);
      expect(menu.id, 'menu1');
      expect(menu.restaurantId, 'rest1');
      expect(menu.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(menu.restaurant.name, 'Restaurant A');
    });
  });

  group('Categories Tests', () {
    test('Categories creation', () {
      final restaurant = Ingredient(id: 'rest1', name: 'Restaurant A');
      final menu = Menu(
        id: 'menu1',
        restaurantId: 'rest1',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
        restaurant: restaurant,
      );
      final categories =
          Categories(id: 'cat1', name: 'Main Course', menu: menu);
      expect(categories.id, 'cat1');
      expect(categories.name, 'Main Course');
      expect(categories.menu.id, 'menu1');
    });

    test('Categories fromJson', () {
      final json = {
        'id': 'cat1',
        'name': 'Main Course',
        'menu': {
          'id': 'menu1',
          'restaurant_id': 'rest1',
          'createdAt': '2023-01-01T00:00:00.000Z',
          'updatedAt': '2023-01-02T00:00:00.000Z',
          'restaurant': {'id': 'rest1', 'name': 'Restaurant A'}
        }
      };
      final categories = Categories.fromJson(json);
      expect(categories.id, 'cat1');
      expect(categories.name, 'Main Course');
      expect(categories.menu.id, 'menu1');
      expect(categories.menu.restaurant.name, 'Restaurant A');
    });
  });

  group('FilterItem Tests', () {
    test('FilterItem creation', () {
      final ingredients = [Ingredient(id: 'ing1', name: 'Salt')];
      final restaurant = Ingredient(id: 'rest1', name: 'Restaurant A');
      final menu = Menu(
        id: 'menu1',
        restaurantId: 'rest1',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
        restaurant: restaurant,
      );
      final categories =
          Categories(id: 'cat1', name: 'Main Course', menu: menu);
      final itemTags = [Ingredient(id: 'tag1', name: 'Spicy')];

      final filterItem = FilterItem(
        id: 'item1',
        name: 'Burger',
        description: 'Tasty burger',
        numberOfReviews: 10,
        averageRating: 4,
        price: 500,
        categoryId: 'cat1',
        fasting: false,
        popularityIndex: 85,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
        ingredients: ingredients,
        categories: categories,
        itemTags: itemTags,
      );

      expect(filterItem.id, 'item1');
      expect(filterItem.name, 'Burger');
      expect(filterItem.description, 'Tasty burger');
      expect(filterItem.numberOfReviews, 10);
      expect(filterItem.averageRating, 4);
      expect(filterItem.price, 500);
      expect(filterItem.categoryId, 'cat1');
      expect(filterItem.fasting, false);
      expect(filterItem.popularityIndex, 85);
      expect(filterItem.ingredients.length, 1);
      expect(filterItem.categories.id, 'cat1');
      expect(filterItem.itemTags.length, 1);
    });

    test('FilterItem fromJson', () {
      final json = {
        'id': 'item1',
        'name': 'Burger',
        'description': 'Tasty burger',
        'number_of_reviews': 10,
        'average_rating': 4,
        'price': 500,
        'category_id': 'cat1',
        'fasting': false,
        'popularity_index': 85,
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-02T00:00:00.000Z',
        'ingredients': [
          {'id': 'ing1', 'name': 'Salt'}
        ],
        'categories': {
          'id': 'cat1',
          'name': 'Main Course',
          'menu': {
            'id': 'menu1',
            'restaurant_id': 'rest1',
            'createdAt': '2023-01-01T00:00:00.000Z',
            'updatedAt': '2023-01-02T00:00:00.000Z',
            'restaurant': {'id': 'rest1', 'name': 'Restaurant A'}
          }
        },
        'item_tags': [
          {'id': 'tag1', 'name': 'Spicy'}
        ]
      };

      final filterItem = FilterItem.fromJson(json);
      expect(filterItem.id, 'item1');
      expect(filterItem.name, 'Burger');
      expect(filterItem.numberOfReviews, 10);
      expect(filterItem.averageRating, 4);
      expect(filterItem.price, 500);
      expect(filterItem.fasting, false);
      expect(filterItem.popularityIndex, 85);
      expect(filterItem.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(filterItem.ingredients[0].name, 'Salt');
      expect(filterItem.categories.name, 'Main Course');
      expect(filterItem.itemTags[0].name, 'Spicy');
    });
  });
}
