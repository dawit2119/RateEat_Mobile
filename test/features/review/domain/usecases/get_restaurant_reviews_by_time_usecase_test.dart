import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_restaurant_reviews_by_time_usecase.dart';

import 'add_restaurant_review_usecase_test.mocks.dart';

void main() {
  late GetRestaurantReviewsByTimeUseCase getRestaurantReviewsByTimeUseCase;
  late MockRestaurantReviewRepository mockRestaurantReviewRepository;

  setUp(() {
    mockRestaurantReviewRepository = MockRestaurantReviewRepository();
    getRestaurantReviewsByTimeUseCase = GetRestaurantReviewsByTimeUseCase(
      repository: mockRestaurantReviewRepository,
    );
  });

  const testGetRecentRestaurantReviewsParams = GetRecentRestaurantReviewsParams(
    restaurantId: '1',
    page: 1,
    limit: 5,
  );

  final testResponse = RestaurantReviewsResponse(
    reviews: [],
    ratingsCount: [],
    averageRating: 0,
    numberOfReviews: 0,
  );

  group('GetRestaurantReviewsByTimeUseCase', () {
    test(
        'should return a RestaurantReviewsResponse when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockRestaurantReviewRepository.getRestaurantReviewsByTime(
          restaurantId: testGetRecentRestaurantReviewsParams.restaurantId,
          limit: testGetRecentRestaurantReviewsParams.limit,
          page: testGetRecentRestaurantReviewsParams.page,
        ),
      ).thenAnswer((_) async => Right(testResponse));
      // act
      final result = await getRestaurantReviewsByTimeUseCase(
        testGetRecentRestaurantReviewsParams,
      );
      // assert
      expect(result, Right(testResponse));
      verify(
        mockRestaurantReviewRepository.getRestaurantReviewsByTime(
          restaurantId: testGetRecentRestaurantReviewsParams.restaurantId,
          limit: testGetRecentRestaurantReviewsParams.limit,
          page: testGetRecentRestaurantReviewsParams.page,
        ),
      );
      verifyNoMoreInteractions(mockRestaurantReviewRepository);
    });
  });
}
