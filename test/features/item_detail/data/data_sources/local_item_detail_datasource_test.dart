import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data_sources/local_item_detail_datasource.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';

import 'local_item_detail_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Box>(),
])
void main() {
  late LocalItemDetailDataSource dataSource;
  late MockBox<Item> mockItemDetailBox;
  late MockBox<PopularItemReviewsResponse> mockPopularItemReviewsBox;
  late MockBox<String> mockRecommendedItemsBox;

  setUp(() {
    mockItemDetailBox = MockBox<Item>();
    mockPopularItemReviewsBox = MockBox<PopularItemReviewsResponse>();
    mockRecommendedItemsBox = MockBox<String>();

    dataSource = LocalItemDetailDataSource(
      itemDetailBox: mockItemDetailBox,
      popularItemReviewsBox: mockPopularItemReviewsBox,
      recommendedItemsBox: mockRecommendedItemsBox,
    );
  });

  group('LocalItemDetailDataSource', () {
    final String itemId = 'item1';
    final Item mockItem =
        Item(itemId: itemId, itemName: 'Test Item', numberOfReviews: 4);
    final PopularItemReviewsResponse mockReviews = PopularItemReviewsResponse(
        ratingsCount: [0, 0, 0, 0, 0],
        averageRating: 0,
        numberOfReviews: 0,
        reviews: []);
    final List<Item> mockRecommendedItems = [mockItem];

    test('getItemDetail returns Item on success', () async {
      when(mockItemDetailBox.get(itemId)).thenReturn(mockItem);

      final result = await dataSource.getItemDetail(itemId);

      expect(result, ItemModel.fromEntity(mockItem));
      verify(mockItemDetailBox.get(itemId)).called(1);
    });

    test('getItemDetail throws Exception when item not found', () async {
      when(mockItemDetailBox.get(itemId)).thenReturn(null);

      expect(() async => await dataSource.getItemDetail(itemId),
          throwsA(isA<Exception>()));
    });

    test('saveItemDetail saves item and deletes oldest if limit exceeded',
        () async {
      when(mockItemDetailBox.length).thenReturnInOrder([
        21,
        20,
        19,
      ]);
      when(mockItemDetailBox.keys).thenReturn(["other id"]);

      await dataSource.saveItemDetail(mockItem);

      verify(mockItemDetailBox.delete(any)).called(2);
      verify(mockItemDetailBox.put(itemId, mockItem)).called(1);
    });

    test('saveItemDetail doesnt delete oldest if item exists', () async {
      when(mockItemDetailBox.length).thenReturnInOrder([
        21,
        20,
        19,
      ]);
      when(mockItemDetailBox.keys).thenReturn([itemId]);

      await dataSource.saveItemDetail(mockItem);

      verifyNever(mockItemDetailBox.delete(any));
      verify(mockItemDetailBox.put(itemId, mockItem)).called(1);
    });

    test('saveItemDetail saves item when under limit', () async {
      when(mockItemDetailBox.length).thenReturn(19);

      await dataSource.saveItemDetail(mockItem);

      verify(mockItemDetailBox.put(itemId, mockItem)).called(1);
    });

    test('deleteItemDetail deletes item', () async {
      await dataSource.deleteItemDetail(itemId);

      verify(mockItemDetailBox.delete(itemId)).called(1);
    });

    test('getPopularItemReviews returns reviews on success', () async {
      when(mockPopularItemReviewsBox.get(itemId)).thenReturn(mockReviews);

      final result = await dataSource.getPopularItemReviews(itemId);

      expect(result, mockReviews);
      verify(mockPopularItemReviewsBox.get(itemId)).called(1);
    });

    test(
        'savePopularItemReviews saves reviews and deletes oldest if limit exceeded',
        () async {
      when(mockPopularItemReviewsBox.length).thenReturnInOrder([21, 20, 19]);
      when(mockPopularItemReviewsBox.keys).thenReturn(['other id']);

      await dataSource.savePopularItemReviews(itemId, mockReviews);

      verify(mockPopularItemReviewsBox.delete(any)).called(2);
      verify(mockPopularItemReviewsBox.put(itemId, mockReviews)).called(1);
    });
    test('savePopularItemReviews doesnt delete if reviews already exist',
        () async {
      when(mockPopularItemReviewsBox.length).thenReturnInOrder([21, 20, 19]);
      when(mockPopularItemReviewsBox.keys).thenReturn([itemId]);

      await dataSource.savePopularItemReviews(itemId, mockReviews);

      verifyNever(mockPopularItemReviewsBox.delete(any));
      verify(mockPopularItemReviewsBox.put(itemId, mockReviews)).called(1);
    });

    test('deletePopularItemReviews deletes reviews', () async {
      await dataSource.deletePopularItemReviews(itemId);

      verify(mockPopularItemReviewsBox.delete(itemId)).called(1);
    });

    test('getRecommendedItems returns items on success', () async {
      final jsonString = '[{"itemId": "item1", "itemName": "Test Item"}]';
      when(mockRecommendedItemsBox.get(itemId)).thenReturn(jsonString);

      final result = await dataSource.getRecommendedItems(itemId);

      expect(result, isA<List<Item>>());
      expect(result!.first.itemName, 'Test Item');
      verify(mockRecommendedItemsBox.get(itemId)).called(1);
    });

    test('saveRecommendedItems saves items as JSON', () async {
      when(mockRecommendedItemsBox.length).thenReturn(19);

      await dataSource.saveRecommendedItems(itemId, mockRecommendedItems);

      verify(mockRecommendedItemsBox.put(itemId, any)).called(1);
    });

    test('deleteRecommendedItems deletes items', () async {
      await dataSource.deleteRecommendedItems(itemId);

      verify(mockRecommendedItemsBox.delete(itemId)).called(1);
    });
  });
}
