import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_category/data/dataprovider/local_item_category_data_provider.dart';

import 'local_item_catagory_data_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Box>(),
])
void main() {
  late LocalItemCategoryDataProviderImpl dataProvider;
  late MockBox<ItemCategory> mockBox;

  setUp(() {
    mockBox = MockBox<ItemCategory>();
    dataProvider = LocalItemCategoryDataProviderImpl(itemCategoryBox: mockBox);
  });

  group('LocalItemCategoryDataProviderImpl', () {
    test('getItemCategories returns list of ItemCategory', () async {
      // Arrange
      final mockCategories = [
        ItemCategory(
            id: "1",
            name: "Fruits"), // Adjust according to your ItemCategory model
        ItemCategory(id: "2", name: "Vegetables"),
      ];
      when(mockBox.values).thenReturn(mockCategories);

      // Act
      final result = await dataProvider.getItemCategories();

      // Assert
      expect(result, isA<List<ItemCategory>>());
      expect(result.length, 2);
      expect(result[0].name, "Fruits");
      expect(result[1].name, "Vegetables");
    });

    test('cacheItemCategories adds item categories to the box', () async {
      // Arrange
      final itemCategories = [
        ItemCategory(id: "1", name: "Dairy"),
        ItemCategory(id: "2", name: "Grains"),
      ];

      // Act
      await dataProvider.cacheItemCategories(itemCategories);

      // Assert
      for (var itemCategory in itemCategories) {
        verify(mockBox.add(itemCategory)).called(1);
      }
    });

    test('clearItemCategories clears the box', () async {
      // Act
      await dataProvider.clearItemCategories();

      // Assert
      verify(mockBox.clear()).called(1);
    });
  });
}
