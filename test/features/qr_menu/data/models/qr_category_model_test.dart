import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('QRCategoryModel', () {
    test('should create a QRCategoryModel from valid map', () {
      // Given
      final data = {
        'id': 'category_id',
        'name': 'Category Name',
        'imageUri': 'https://example.com/image.jpg',
      };

      // When
      final category = QRCategoryModel.fromMap(data);

      // Then
      expect(category.id, 'category_id');
      expect(category.name, 'Category Name');
      expect(category.imageUri, 'https://example.com/image.jpg');
    });

    test('should handle missing fields and return defaults', () {
      // Given
      final data = {
        'id': null,
        'name': null,
        'imageUri': null,
      };

      // When
      final category = QRCategoryModel.fromMap(data);

      // Then
      expect(category.id, ''); // Default value for null
      expect(category.name, ''); // Default value for null
      expect(category.imageUri, ''); // Default value for null
    });

    test('should create a QRCategoryModel with empty strings', () {
      // Given
      final data = {
        'id': '',
        'name': '',
        'imageUri': '',
      };

      // When
      final category = QRCategoryModel.fromMap(data);

      // Then
      expect(category.id, '');
      expect(category.name, '');
      expect(category.imageUri, '');
    });
  });
}
