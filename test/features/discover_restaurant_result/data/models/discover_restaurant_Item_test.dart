import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/discover_restaurant_item_model.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/item_image.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/item_tag.dart';

void main() {
  group('DiscoverRestaurantItem', () {
    test('should create an instance with given properties', () {
      final item = DiscoverRestaurantItem(
        id: '1',
        name: 'Pizza',
        price: 12.99,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 250.0,
        itemTags: [
          ItemTag(
            name: 'Italian',
            id: "1",
          )
        ],
        itemImages: [ItemImage(url: 'http://example.com/image.png')],
      );

      expect(item.id, '1');
      expect(item.name, 'Pizza');
      expect(item.price, 12.99);
      expect(item.averageRating, 4.5);
      expect(item.numberOfReviews, 100);
      expect(item.popularityIndex, 250.0);
      expect(item.itemTags, isA<List<ItemTag>>());
      expect(item.itemImages, isA<List<ItemImage>>());
    });

    test('fromJson should create an instance from JSON', () {
      final restaurantData = {
        'id': '1',
        'name': 'Pizza',
        'price': 12.99,
        'average_rating': 4.5,
        'number_of_reviews': 100,
        'popularity_index': 250.0,
        'item_tags': [
          {'tag': 'Italian'}
        ],
        'item_images': [
          {'url': 'http://example.com/image.png'}
        ],
      };

      final restaurantInfo = {
        // Assuming this data is needed for the image mapping
        'image_path': 'http://example.com/restaurant_image.png',
      };

      final item =
          DiscoverRestaurantItem.fromJson(restaurantData, restaurantInfo);

      expect(item.id, '1');
      expect(item.name, 'Pizza');
      expect(item.price, 12.99);
      expect(item.averageRating, 4.5);
      expect(item.numberOfReviews, 100);
      expect(item.popularityIndex, 250.0);
      expect(item.itemTags!.length, 1);
      expect(item.itemImages!.length, 2);
      expect(item.itemImages![1].url,
          'https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg'); // The image from restaurant data
    });

    test('copyWith should create a new instance with updated values', () {
      const item = DiscoverRestaurantItem(
        id: '1',
        name: 'Pizza',
        price: 12.99,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 250.0,
        itemTags: [],
        itemImages: [],
      );

      final updatedItem = item.copyWith(name: 'Pasta', price: 15.99);

      expect(updatedItem.id, '1');
      expect(updatedItem.name, 'Pasta');
      expect(updatedItem.price, 15.99);
      expect(updatedItem.averageRating, 4.5);
      expect(updatedItem.numberOfReviews, 100);
    });

    test('equality operator should work correctly', () {
      const item1 = DiscoverRestaurantItem(id: '1', name: 'Pizza');
      const item2 = DiscoverRestaurantItem(id: '1', name: 'Pizza');
      const item3 = DiscoverRestaurantItem(id: '2', name: 'Pasta');

      expect(item1, item2); // They should be equal
      expect(item1, isNot(item3)); // They should not be equal
    });
  });
}
