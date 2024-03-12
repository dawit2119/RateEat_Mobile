import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_review_response_model.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/domain.dart';

import 'get_item_usecase_test.mocks.dart';

void main() {
  late GetPopularItemReviewsUseCase getPopularItemReviewsUseCase;
  late MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    getPopularItemReviewsUseCase =
        GetPopularItemReviewsUseCase(reviewRepository: mockItemRepository);
  });

  const testItemId = 'testItemId';
  final testPopularItemReviewsResponse = PopularItemReviewsResponse(
    reviews: [
      PopularItemReviewResponseModel(
        id: 'testReviewId',
      ),
    ],
    ratingsCount: [0, 0, 0, 0, 0],
    averageRating: 0,
    numberOfReviews: 0,
  );
  group('GetPopularItemReviewsUseCase', () {
    test('should call the repository that gets popular item reviews', () async {
      // Arrange
      when(
        mockItemRepository.getPopularItemReviews(
          itemId: testItemId,
        ),
      ).thenAnswer((_) async => Right(testPopularItemReviewsResponse));
      // Act
      final result = await getPopularItemReviewsUseCase(
          const GetItemsPopularReviewsParams(itemId: testItemId));

      // Assert
      expect(result, Right(testPopularItemReviewsResponse));
      verify(
        mockItemRepository.getPopularItemReviews(
          itemId: testItemId,
        ),
      );
      verifyNoMoreInteractions(mockItemRepository);
    });
  });
}
