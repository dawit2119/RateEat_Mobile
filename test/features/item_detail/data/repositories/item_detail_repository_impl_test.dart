import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_review_response_model.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/repositories/item__detail_repository_impl.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';

import 'item_detail_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemDataProvider>(),
])
void main() {
  late ItemRepositoryImpl itemRepositoryImpl;
  late MockItemDataProvider mockItemDataProvider;

  setUp(() {
    mockItemDataProvider = MockItemDataProvider();
    itemRepositoryImpl =
        ItemRepositoryImpl(itemDataProvider: mockItemDataProvider);
  });

  const testItemId = 'testItemId';
  final testPopularItemReviewsResponse = PopularItemReviewsResponseModel(
    reviews: [
      PopularItemReviewResponseModel(
        id: 'testReviewId',
      ),
    ],
    ratingsCount: [0, 0, 0, 0, 0],
    averageRating: 0,
    numberOfReviews: 0,
  );
  final testItemModels = [
    ItemModel(
      itemId: 'testItemId',
      itemName: 'testItemName',
      description: 'testItemDescription',
      price: 10.0,
      imageUrl: 'testImageUrl',
      numberOfReviews: 0,
    )
  ];
  group('getItem', () {
    test('should call the repository that gets an item', () async {
      // Arrange
      when(
        mockItemDataProvider.getItem(
          itemId: testItemId,
        ),
      ).thenAnswer((_) async => testItemModels.first);
      // Act
      final result = await itemRepositoryImpl.getItem(itemId: testItemId);

      // Assert
      expect(result, equals(Right(testItemModels.first)));
      verify(
        mockItemDataProvider.getItem(
          itemId: testItemId,
        ),
      );
      verifyNoMoreInteractions(mockItemDataProvider);
    });

    test(
        'should return a ServerFailure when the call to the repository is unsuccessful',
        () async {
      // Arrange
      when(
        mockItemDataProvider.getItem(
          itemId: testItemId,
        ),
      ).thenThrow(ServerException());
      // Act
      final result = await itemRepositoryImpl.getItem(itemId: testItemId);

      // Assert
      expect(result, equals(Left(ServerFailure())));
      verify(
        mockItemDataProvider.getItem(
          itemId: testItemId,
        ),
      );
      verifyNoMoreInteractions(mockItemDataProvider);
    });
  });

  group('getItemRecommendations', () {
    test('should call the repository that gets item recommendations', () async {
      // Arrange
      when(
        mockItemDataProvider.getItemRecommendations(
          itemId: testItemId,
        ),
      ).thenAnswer((_) async => testItemModels);
      // Act
      final result =
          await itemRepositoryImpl.getItemRecommendations(itemId: testItemId);

      // Assert
      expect(result, equals(Right(testItemModels)));
      verify(
        mockItemDataProvider.getItemRecommendations(
          itemId: testItemId,
        ),
      );
      verifyNoMoreInteractions(mockItemDataProvider);
    });

    test(
        'should return a ServerFailure when the call to the repository is unsuccessful',
        () async {
      // Arrange
      when(
        mockItemDataProvider.getItemRecommendations(
          itemId: testItemId,
        ),
      ).thenThrow(ServerException());
      // Act
      final result =
          await itemRepositoryImpl.getItemRecommendations(itemId: testItemId);

      // Assert
      expect(result, equals(Left(ServerFailure())));
      verify(
        mockItemDataProvider.getItemRecommendations(
          itemId: testItemId,
        ),
      );
      verifyNoMoreInteractions(mockItemDataProvider);
    });
  });

  group('getPopularItemReviews', () {
    test('should call the repository that gets popular item reviews', () async {
      // Arrange
      when(
        mockItemDataProvider.getPopularItemsReviews(
          itemId: testItemId,
        ),
      ).thenAnswer((_) async => testPopularItemReviewsResponse);
      // Act
      final result =
          await itemRepositoryImpl.getPopularItemReviews(itemId: testItemId);

      // Assert
      expect(result, equals(Right(testPopularItemReviewsResponse)));
      verify(
        mockItemDataProvider.getPopularItemsReviews(
          itemId: testItemId,
        ),
      );
      verifyNoMoreInteractions(mockItemDataProvider);
    });

    test(
        'should return a ServerFailure when the call to the repository is unsuccessful',
        () async {
      // Arrange
      when(
        mockItemDataProvider.getPopularItemsReviews(
          itemId: testItemId,
        ),
      ).thenThrow(ServerException());
      // Act
      final result =
          await itemRepositoryImpl.getPopularItemReviews(itemId: testItemId);

      // Assert
      expect(result, equals(Left(ServerFailure())));
      verify(
        mockItemDataProvider.getPopularItemsReviews(
          itemId: testItemId,
        ),
      );
      verifyNoMoreInteractions(mockItemDataProvider);
    });
  });
}
