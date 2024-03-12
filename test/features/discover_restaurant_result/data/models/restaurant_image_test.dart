import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_image.dart';

void main() {
  group('RestaurantImage', () {
    test('should create an instance with given properties', () {
      const restaurantImage =
          RestaurantImage(id: '1', url: 'http://example.com/image.png');

      expect(restaurantImage.id, '1');
      expect(restaurantImage.url, 'http://example.com/image.png');
    });

    test('fromJson should create an instance from JSON', () {
      final jsonData = {
        'id': '1',
        'url': 'http://example.com/image.png',
      };

      final restaurantImage = RestaurantImage.fromJson(jsonData);

      expect(restaurantImage.id, '1');
      expect(restaurantImage.url, 'http://example.com/image.png');
    });

    test('copyWith should create a new instance with updated values', () {
      const restaurantImage =
          RestaurantImage(id: '1', url: 'http://example.com/image.png');

      final updatedImage =
          restaurantImage.copyWith(url: 'http://example.com/new_image.png');

      expect(updatedImage.id, '1');
      expect(updatedImage.url, 'http://example.com/new_image.png');
    });

    test('equality operator should work correctly', () {
      const image1 =
          RestaurantImage(id: '1', url: 'http://example.com/image.png');
      const image2 =
          RestaurantImage(id: '1', url: 'http://example.com/image.png');
      const image3 =
          RestaurantImage(id: '2', url: 'http://example.com/another_image.png');

      expect(image1, image2); // They should be equal
      expect(image1, isNot(image3)); // They should not be equal
    });
  });
}
