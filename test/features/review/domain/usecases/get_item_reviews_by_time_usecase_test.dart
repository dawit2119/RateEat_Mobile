import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_item_reviews_by_time_usecase.dart';

import 'add_item_review_usecase_test.mocks.dart';

void main() {
  late GetItemReviewsByTimeUseCase getItemReviewsByTimeUseCase;
  late MockItemReviewRepository mockItemReviewRepository;

  setUp(() {
    mockItemReviewRepository = MockItemReviewRepository();
    getItemReviewsByTimeUseCase = GetItemReviewsByTimeUseCase(
      repository: mockItemReviewRepository,
    );
  });

  const testGetItemReviewsByTimeParams = GetItemReviewsByTimeParams(
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

  group('GetItemReviewsByTimeUseCase', () {
    test(
        'should return a list of item reviews when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockItemReviewRepository.getItemReviewsByTime(
          itemId: testGetItemReviewsByTimeParams.itemId,
          limit: testGetItemReviewsByTimeParams.limit,
          page: testGetItemReviewsByTimeParams.page,
        ),
      ).thenAnswer((_) async => Right(itemReviewsResponse));
      // act
      final result = await getItemReviewsByTimeUseCase(
        testGetItemReviewsByTimeParams,
      );
      // assert
      expect(result, Right(itemReviewsResponse));
      verify(
        mockItemReviewRepository.getItemReviewsByTime(
          itemId: testGetItemReviewsByTimeParams.itemId,
          limit: testGetItemReviewsByTimeParams.limit,
          page: testGetItemReviewsByTimeParams.page,
        ),
      );
      verifyNoMoreInteractions(mockItemReviewRepository);
    });
  });
}
