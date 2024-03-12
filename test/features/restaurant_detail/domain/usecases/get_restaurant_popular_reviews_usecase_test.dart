import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_review_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_restaurant_popular_reviews_usecase.dart';

import 'restaurant_detail_usecase_test.mocks.dart';

void main() {
  late GetPopularRestaurantReviewsUseCase getPopularRestaurantReviewsUseCase;
  late MockRestaurantDetailRepository mockRestaurantDetailRepository;

  setUp(() {
    mockRestaurantDetailRepository = MockRestaurantDetailRepository();
    getPopularRestaurantReviewsUseCase = GetPopularRestaurantReviewsUseCase(
      repository: mockRestaurantDetailRepository,
    );
  });

  const testRestaurantId = "restaurantId";
  final testPopularRestaurantReviewsResponse = PopularRestaurantReviewsResponse(
    reviews: [
      PopularRestaurantReviewResponseModel(
        id: 'testReviewId',
      ),
    ],
    ratingsCount: [0, 0, 0, 0, 0],
    averageRating: 0,
    numberOfReviews: 0,
  );

  group('Get Popular Restaurant Reviews UseCase', () {
    test('should call the repository that gets popular restaurant reviews',
        () async {
      // Arrange
      when(
        mockRestaurantDetailRepository.getPopularRestaurantReviews(
          restaurantId: testRestaurantId,
        ),
      ).thenAnswer((_) async => Right(testPopularRestaurantReviewsResponse));
      // Act
      final result = await getPopularRestaurantReviewsUseCase(
        const GetRestaurantPopularReviewsParams(restaurantId: testRestaurantId),
      );
      // Assert
      expect(result, Right(testPopularRestaurantReviewsResponse));
      verify(
        mockRestaurantDetailRepository.getPopularRestaurantReviews(
          restaurantId: testRestaurantId,
        ),
      );
      verifyNoMoreInteractions(mockRestaurantDetailRepository);
    });
  });
}
