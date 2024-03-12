import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_restaurant_review_usecase.dart';

import 'add_restaurant_review_usecase_test.mocks.dart';

void main() {
  late DeleteRestaurantReviewUseCase deleteRestaurantReviewUseCase;
  late MockRestaurantReviewRepository mockRestaurantReviewRepository;

  setUp(() {
    mockRestaurantReviewRepository = MockRestaurantReviewRepository();
    deleteRestaurantReviewUseCase = DeleteRestaurantReviewUseCase(
      repository: mockRestaurantReviewRepository,
    );
  });

  final testDeleteRestaurantReview = DeleteRestaurantReviewUseCaseParams(
    deleteRestaurantReviewRequestModel: DeleteRestaurantReviewRequestModel(
      restaurantId: '1',
      reviewId: 'reviewId',
    ),
  );

  // Test the DeleteRestaurantReviewUseCase class
  group('DeleteRestaurantReviewUseCase', () {
    test('should return a string when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockRestaurantReviewRepository.deleteRestaurantReview(
          deleteRestaurantReviewRequestModel:
              testDeleteRestaurantReview.deleteRestaurantReviewRequestModel,
        ),
      ).thenAnswer((_) async => const Right('Review deleted successfully'));
      // act
      final result =
          await deleteRestaurantReviewUseCase(testDeleteRestaurantReview);
      // assert
      expect(result, const Right('Review deleted successfully'));
      verify(
        mockRestaurantReviewRepository.deleteRestaurantReview(
          deleteRestaurantReviewRequestModel:
              testDeleteRestaurantReview.deleteRestaurantReviewRequestModel,
        ),
      );
      verifyNoMoreInteractions(mockRestaurantReviewRepository);
    });
  });
}
