import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('ItemCategoryModel', () {
    test('fromJson creates an ItemCategoryModel from JSON', () {
      // Arrange
      final jsonData = {
        'id': '1',
        'name': 'Fruits',
        'item_id': '101',
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-02T00:00:00.000Z',
        'icon': 'https://example.com/icon.png',
      };

      // Act
      final model = ItemCategoryModel.fromJson(jsonData);

      // Assert
      expect(model.id, '1');
      expect(model.name, 'Fruits');
      expect(model.itemId, '101');
      expect(model.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(model.updatedAt, DateTime.parse('2023-01-02T00:00:00.000Z'));
      expect(model.iconUrl, 'https://example.com/icon.png');
    });

    test('toJson converts an ItemCategoryModel to JSON', () {
      // Arrange
      final model = ItemCategoryModel(
        id: '1',
        name: 'Fruits',
        itemId: '101',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
        iconUrl: 'https://example.com/icon.png',
      );

      // Act
      final jsonResult = model.toJson();

      // Assert
      expect(jsonResult['id'], '1');
      expect(jsonResult['name'], 'Fruits');
      expect(jsonResult['item_id'], '101');
      expect(jsonResult['createdAt'], '2023-01-01T00:00:00.000Z');
      expect(jsonResult['updatedAt'], '2023-01-02T00:00:00.000Z');
      expect(jsonResult['icon'], 'https://example.com/icon.png');
    });

    test('fromEntity creates an ItemCategoryModel from ItemCategory entity',
        () {
      // Arrange
      final entity = ItemCategory(
        id: '2',
        name: 'Vegetables',
        itemId: '102',
        createdAt: DateTime.parse('2023-01-03T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-04T00:00:00.000Z'),
        iconUrl: 'https://example.com/icon2.png',
      );

      // Act
      final model = ItemCategoryModel.fromEntity(entity);

      // Assert
      expect(model.id, '2');
      expect(model.name, 'Vegetables');
      expect(model.itemId, '102');
      expect(model.createdAt, DateTime.parse('2023-01-03T00:00:00.000Z'));
      expect(model.updatedAt, DateTime.parse('2023-01-04T00:00:00.000Z'));
      expect(model.iconUrl, 'https://example.com/icon2.png');
    });

    test('copyWith creates a copy with modified fields', () {
      // Arrange
      final model = ItemCategoryModel(
        id: '1',
        name: 'Fruits',
        itemId: '101',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
        iconUrl: 'https://example.com/icon.png',
      );

      // Act
      final updatedModel = model.copyWith(name: 'Vegetables');

      // Assert
      expect(updatedModel.id, model.id);
      expect(updatedModel.name, 'Vegetables');
      expect(updatedModel.itemId, model.itemId);
      expect(updatedModel.createdAt, model.createdAt);
      expect(updatedModel.updatedAt, model.updatedAt);
      expect(updatedModel.iconUrl, model.iconUrl);
    });

    test('props are correctly defined for equality checks', () {
      // Arrange
      final model1 = ItemCategoryModel(
        id: '1',
        name: 'Fruits',
        itemId: '101',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
        iconUrl: 'https://example.com/icon.png',
      );

      final model2 = ItemCategoryModel(
        id: '1',
        name: 'Fruits',
        itemId: '101',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
        iconUrl: 'https://example.com/icon.png',
      );

      final model3 = ItemCategoryModel(
        id: '2',
        name: 'Vegetables',
        itemId: '102',
        createdAt: DateTime.parse('2023-01-03T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-04T00:00:00.000Z'),
        iconUrl: 'https://example.com/icon2.png',
      );

      // Assert
      expect(model1, model2); // Should be equal
      expect(model1, isNot(model3)); // Should not be equal
    });
  });
}
