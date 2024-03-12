import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_restaurant_reviews_by_popularity_usecase.dart';

import 'add_restaurant_review_usecase_test.mocks.dart';

void main() {
  late GetRestaurantReviewsByPopularityUseCase
      getRestaurantReviewsByPopularityUseCase;
  late MockRestaurantReviewRepository mockRestaurantReviewRepository;

  setUp(() {
    mockRestaurantReviewRepository = MockRestaurantReviewRepository();
    getRestaurantReviewsByPopularityUseCase =
        GetRestaurantReviewsByPopularityUseCase(
      repository: mockRestaurantReviewRepository,
    );
  });

  const testGetPopularRestaurantReviewsParams =
      GetPopularRestaurantReviewsParams(
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

  group('GetRestaurantReviewsByPopularityUseCase', () {
    test(
        'should return a RestaurantReviewsResponse when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockRestaurantReviewRepository.getRestaurantReviewsByPopularity(
          restaurantId: testGetPopularRestaurantReviewsParams.restaurantId,
          limit: testGetPopularRestaurantReviewsParams.limit,
          page: testGetPopularRestaurantReviewsParams.page,
        ),
      ).thenAnswer((_) async => Right(testResponse));
      // act
      final result = await getRestaurantReviewsByPopularityUseCase(
        testGetPopularRestaurantReviewsParams,
      );
      // assert
      expect(result, Right(testResponse));
      verify(
        mockRestaurantReviewRepository.getRestaurantReviewsByPopularity(
          restaurantId: testGetPopularRestaurantReviewsParams.restaurantId,
          limit: testGetPopularRestaurantReviewsParams.limit,
          page: testGetPopularRestaurantReviewsParams.page,
        ),
      );
      verifyNoMoreInteractions(mockRestaurantReviewRepository);
    });
  });
}
