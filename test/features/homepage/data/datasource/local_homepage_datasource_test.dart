import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/homepage/data/datasource/local_homepage_dataprovider.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

import 'local_homepage_datasource_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  group('LocalHomepageDataproviderImpl', () {
    late LocalHomepageDataproviderImpl dataprovider;
    late MockBox<Item> mockBox;

    setUp(() {
      mockBox = MockBox<Item>();
      dataprovider = LocalHomepageDataproviderImpl(itemBox: mockBox);
    });

    test('cacheTopRatedItems should add items to the box', () async {
      final items = [
        Item(itemId: "1", itemName: "item 1", numberOfReviews: 4),
        Item(itemId: "2", itemName: "item 2", numberOfReviews: 4),
      ];

      when(mockBox.add(any)).thenAnswer((_) async => 1);

      await dataprovider.cacheTopRatedItems(items);

      verify(mockBox.add(items[0])).called(1);
      verify(mockBox.add(items[1])).called(1);
    });

    test('clearTopRatedItems should clear the box', () async {
      when(mockBox.clear()).thenAnswer((_) async => 1);

      await dataprovider.clearTopRatedItems();

      verify(mockBox.clear()).called(1);
    });

    test('getTopRatedItems should return a list of items from the box',
        () async {
      final items = [
        Item(itemId: "1", itemName: "item 1", numberOfReviews: 4),
        Item(itemId: "2", itemName: "item 2", numberOfReviews: 4),
      ];

      when(mockBox.values).thenReturn(items);

      final result = await dataprovider.getTopRatedItems();

      expect(result, equals(items));
      verify(mockBox.values).called(1);
    });
  });
}
