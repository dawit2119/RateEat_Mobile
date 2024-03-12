import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_item_reviews_by_popularity_usecase.dart';

import 'add_item_review_usecase_test.mocks.dart';

void main() {
  late GetItemReviewsByPopularityUseCase getItemReviewsByPopularityUseCase;
  late MockItemReviewRepository mockItemReviewRepository;

  setUp(() {
    mockItemReviewRepository = MockItemReviewRepository();
    getItemReviewsByPopularityUseCase = GetItemReviewsByPopularityUseCase(
      repository: mockItemReviewRepository,
    );
  });

  const testGetItemReviewsByPopularityParams = GetItemReviewsByPopularityParams(
    itemId: '1',
    page: 1,
    limit: 5,
  );

  final itemReviewsResponse = ItemReviewsResponse(
    reviews: [],
    ratingsCount: [],
    averageRating: 0,
    numberOfReviews: 0,
  );

  group('GetItemReviewsByPopularityUseCase', () {
    test(
        'should return a list of item reviews when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockItemReviewRepository.getItemReviewsByPopularity(
          itemId: testGetItemReviewsByPopularityParams.itemId,
          limit: testGetItemReviewsByPopularityParams.limit,
          page: testGetItemReviewsByPopularityParams.page,
        ),
      ).thenAnswer((_) async => Right(itemReviewsResponse));
      // act
      final result = await getItemReviewsByPopularityUseCase(
        testGetItemReviewsByPopularityParams,
      );
      // assert
      expect(result, Right(itemReviewsResponse));
      verify(
        mockItemReviewRepository.getItemReviewsByPopularity(
          itemId: testGetItemReviewsByPopularityParams.itemId,
          limit: testGetItemReviewsByPopularityParams.limit,
          page: testGetItemReviewsByPopularityParams.page,
        ),
      );
      verifyNoMoreInteractions(mockItemReviewRepository);
    });
  });
}
