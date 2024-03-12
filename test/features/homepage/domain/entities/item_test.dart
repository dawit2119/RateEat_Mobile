import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

void main() {
  group('Item Tests', () {
    late Item item;

    setUp(() {
      item = Item(
        itemId: '1',
        itemName: 'Pasta',
        numberOfReviews: 20,
        description: 'Delicious pasta with tomato sauce.',
        averageRating: 4.5,
        price: 12.99,
        restaurantName: 'Italian Bistro',
        imageUrl: 'http://example.com/pasta.jpg',
        itemImages: [
          ItemMedia(
              id: 'img1', url: 'http://example.com/img1.jpg', isLeading: true),
        ],
        itemVideos: [
          ItemMedia(id: 'vid1', url: 'http://example.com/video1.mp4'),
        ],
        tags: ['Italian', 'Main Course'],
        categoryId: 'cat1',
        fasting: false,
        priceUpdatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        ingredients: [
          Ingredient(id: 'ing1', name: 'Tomato', itemId: '1'),
        ],
        categories: null,
        minutes: 15,
        isOpen: true,
        isFavorite: false,
        distance: '1 km',
        ridingTime: '5 mins',
        walkingTime: '15 mins',
      );
    });

    test('should create an Item instance', () {
      expect(item.itemId, '1');
      expect(item.itemName, 'Pasta');
      expect(item.numberOfReviews, 20);
      expect(item.averageRating, 4.5);
      expect(item.price, 12.99);
      expect(item.restaurantName, 'Italian Bistro');
    });

    test('should convert Item to Map', () {
      final map = item.toMap();

      expect(map['itemId'], item.itemId);
      expect(map['itemName'], item.itemName);
      expect(map['numberOfReviews'], item.numberOfReviews);
      expect(map['description'], item.description);
      expect(map['averageRating'], item.averageRating);
      expect(map['price'], item.price);
      expect(map['imageUrl'], item.imageUrl);
      expect(
          map['itemImages'], item.itemImages?.map((e) => e.toJson()).toList());
    });

    test('should convert Item to JSON', () {
      final json = item.toStringJson();

      expect(json, isA<String>());
      expect(json, contains('"itemId":"1"'));
      expect(json, contains('"itemName":"Pasta"'));
    });

    test('copyWith should return a new Item instance', () {
      final updatedItem = item.copyWith(itemName: 'Spaghetti');

      expect(updatedItem.itemId, item.itemId);
      expect(updatedItem.itemName, 'Spaghetti');
      expect(updatedItem.numberOfReviews, item.numberOfReviews);
    });
  });

  group('Ingredient Tests', () {
    late Ingredient ingredient;

    setUp(() {
      ingredient = Ingredient(
        id: 'ing1',
        name: 'Tomato',
        itemId: '1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    test('should create an Ingredient instance', () {
      expect(ingredient.id, 'ing1');
      expect(ingredient.name, 'Tomato');
      expect(ingredient.itemId, '1');
    });

    test('should convert Ingredient to JSON', () {
      final json = ingredient.toJson();

      expect(json['id'], ingredient.id);
      expect(json['name'], ingredient.name);
      expect(json['item_id'], ingredient.itemId);
    });

    test('should create Ingredient from JSON', () {
      final json = {
        'id': 'ing2',
        'name': 'Lettuce',
        'item_id': '2',
      };

      final newIngredient = Ingredient.fromJson(json);

      expect(newIngredient.id, 'ing2');
      expect(newIngredient.name, 'Lettuce');
      expect(newIngredient.itemId, '2');
    });
  });

  group('ItemMedia Tests', () {
    late ItemMedia itemMedia;

    setUp(() {
      itemMedia = ItemMedia(
        id: 'img1',
        url: 'http://example.com/image.jpg',
        isLeading: true,
      );
    });

    test('should create an ItemMedia instance', () {
      expect(itemMedia.id, 'img1');
      expect(itemMedia.url, 'http://example.com/image.jpg');
      expect(itemMedia.isLeading, true);
    });

    test('should convert ItemMedia to JSON', () {
      final json = itemMedia.toJson();

      expect(json['id'], itemMedia.id);
      expect(json['url'], itemMedia.url);
      expect(json['is_leading'], itemMedia.isLeading);
    });

    test('should create ItemMedia from JSON', () {
      final json = {
        'id': 'vid1',
        'url': 'http://example.com/video.mp4',
        'is_leading': false,
      };

      final newItemMedia = ItemMedia.fromJson(json);

      expect(newItemMedia.id, 'vid1');
      expect(newItemMedia.url, 'http://example.com/video.mp4');
      expect(newItemMedia.isLeading, false);
    });
  });
}
