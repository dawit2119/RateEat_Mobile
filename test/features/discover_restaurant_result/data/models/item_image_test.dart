import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/item_image.dart';

void main() {
  group('ItemImage', () {
    test('should create an instance with given properties', () {
      const itemImage = ItemImage(id: '1', url: 'http://example.com/image.png');

      expect(itemImage.id, '1');
      expect(itemImage.url, 'http://example.com/image.png');
    });

    test('fromJson should create an instance from JSON', () {
      final jsonData = {
        'id': '1',
        'url': 'http://example.com/image.png',
      };

      final itemImage = ItemImage.fromJson(jsonData);

      expect(itemImage.id, '1');
      expect(itemImage.url, 'http://example.com/image.png');
    });

    test('copyWith should create a new instance with updated values', () {
      const itemImage = ItemImage(id: '1', url: 'http://example.com/image.png');

      final updatedImage =
          itemImage.copyWith(url: 'http://example.com/new_image.png');

      expect(updatedImage.id, '1');
      expect(updatedImage.url, 'http://example.com/new_image.png');
    });

    test('equality operator should work correctly', () {
      const image1 = ItemImage(id: '1', url: 'http://example.com/image.png');
      const image2 = ItemImage(id: '1', url: 'http://example.com/image.png');
      const image3 =
          ItemImage(id: '2', url: 'http://example.com/another_image.png');

      expect(image1, image2); // They should be equal
      expect(image1, isNot(image3)); // They should not be equal
    });
  });
}
