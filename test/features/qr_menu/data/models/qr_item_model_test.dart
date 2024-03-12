import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('QRItemModel', () {
    test('should create a QRItemModel from valid map', () {
      // Given
      final json = {
        'category_id': 'category_id',
        'fasting': false,
        'name': 'Item Name',
        'average_rating': 4.5,
        'price': 100,
        'number_of_reviews': 10,
        'id': 'item_id',
        'item_images': [
          {'url': 'https://example.com/image.jpg'},
        ],
      };

      // When
      final item = QRItemModel.fromMap(json);

      // Then
      expect(item.categoryId, 'category_id');
      expect(item.isFasting, false);
      expect(item.name, 'Item Name');
      expect(item.rating, 4.5);
      expect(item.price, 100);
      expect(item.numberOfReviews, 10);
      expect(item.id, 'item_id');
      expect(item.imageUrl, 'https://example.com/image.jpg');
    });

    test('should use default image URL when item_images is empty', () {
      // Given
      final json = {
        'category_id': 'category_id',
        'fasting': false,
        'name': 'Item Name',
        'average_rating': null,
        'price': 50,
        'number_of_reviews': 5,
        'id': 'item_id',
        'item_images': [],
      };

      // When
      final item = QRItemModel.fromMap(json);

      // Then
      expect(item.imageUrl,
          'https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1734682325169-high.webp');
    });

    test('should default average_rating to 0.0 if not present', () {
      // Given
      final json = {
        'category_id': 'category_id',
        'fasting': false,
        'name': 'Item Name',
        'price': 50,
        'number_of_reviews': 5,
        'id': 'item_id',
        'item_images': [
          {'url': 'https://example.com/image.jpg'},
        ],
      };

      // When
      final item = QRItemModel.fromMap(json);

      // Then
      expect(item.rating, 0.0); // Default value
    });

    test('should convert integer average_rating to double', () {
      // Given
      final json = {
        'category_id': 'category_id',
        'fasting': false,
        'name': 'Item Name',
        'average_rating': 5, // integer
        'price': 20,
        'number_of_reviews': 3,
        'id': 'item_id',
        'item_images': [],
      };

      // When
      final item = QRItemModel.fromMap(json);

      // Then
      expect(item.rating, 5.0); // Should convert to double
    });
  });
}
