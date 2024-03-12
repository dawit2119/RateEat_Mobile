import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'item_model_test.mocks.dart';

@GenerateMocks([Box<ItemModel>])
void main() {
  group('ItemModel Tests', () {
    late ItemModel itemModel;

    setUp(() {
      itemModel = ItemModel(
        itemId: '1',
        itemName: 'Test Item',
        numberOfReviews: 10,
        averageRating: 4.5,
        description: 'A tasty test item.',
        restaurantName: 'Test Restaurant',
        price: 9.99,
        imageUrl: 'http://example.com/image.jpg',
        itemImages: [],
        itemVideos: [],
        tags: ['test', 'item'],
        categoryId: 'cat123',
        fasting: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        ingredients: [],
        categories: null,
        minutes: 30,
        isOpen: true,
        isFavorite: false,
        distance: '0.5 miles',
        walkingTime: '10 mins',
        ridingTime: '5 mins',
      );
    });

    test('should create an ItemModel instance', () {
      expect(itemModel.itemId, '1');
      expect(itemModel.itemName, 'Test Item');
      expect(itemModel.numberOfReviews, 10);
      expect(itemModel.averageRating, 4.5);
    });

    test('should convert ItemModel to JSON', () {
      final json = itemModel.toJson();

      expect(json['id'], itemModel.itemId);
      expect(json['name'], itemModel.itemName);
      expect(json['number_of_reviews'], itemModel.numberOfReviews);
      expect(json['average_rating'], itemModel.averageRating);
    });

    test('should create ItemModel from JSON', () {
      final json = {
        'id': '2',
        'name': 'Another Item',
        'number_of_reviews': 5,
        'average_rating': 3.5,
        'price': 8.99,
      };

      final newItem = ItemModel.fromJson(json);

      expect(newItem.itemId, '2');
      expect(newItem.itemName, 'Another Item');
      expect(newItem.numberOfReviews, 5);
      expect(newItem.averageRating, 3.5);
    });

    test('should create ItemModel from cache JSON', () {
      final json = {
        'itemId': '3',
        'itemName': 'Cached Item',
        'numberOfReviews': 7,
        'averageRating': 4.0,
      };

      final cachedItem = ItemModel.fromCacheJson(json);

      expect(cachedItem.itemId, '3');
      expect(cachedItem.itemName, 'Cached Item');
      expect(cachedItem.numberOfReviews, 7);
      expect(cachedItem.averageRating, 4.0);
    });

    test('should copy ItemModel with new values', () {
      final updatedItem = itemModel.copyWith(itemName: 'Updated Item');

      expect(updatedItem.itemId, itemModel.itemId);
      expect(updatedItem.itemName, 'Updated Item');
      expect(updatedItem.numberOfReviews, itemModel.numberOfReviews);
    });

    test('should handle Hive operations', () {
      // Create a mock Hive box
      final mockBox = MockBox<ItemModel>();
      when(mockBox.get('1')).thenReturn(itemModel);

      // Simulate saving the item
      mockBox.put('1', itemModel);
      verify(mockBox.put('1', itemModel)).called(1);

      // Simulate fetching the item
      final fetchedItem = mockBox.get('1');
      expect(fetchedItem?.itemId, itemModel.itemId);
    });
  });
}
