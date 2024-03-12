import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/edit_restaurant_review_usecase.dart';

import 'add_restaurant_review_usecase_test.mocks.dart';

void main() {
  late EditRestaurantReviewUseCase editRestaurantReviewUseCase;
  late MockRestaurantReviewRepository mockRestaurantReviewRepository;

  setUp(() {
    mockRestaurantReviewRepository = MockRestaurantReviewRepository();
    editRestaurantReviewUseCase = EditRestaurantReviewUseCase(
      repository: mockRestaurantReviewRepository,
    );
  });

  final testEditRestaurantReview = EditRestaurantReviewUseCaseParams(
    editRestaurantReviewRequestModel: EditRestaurantReviewRequestModel(
      restaurantId: '1',
      reviewId: 'review',
      rating: 5,
    ),
  );

  // Test the EditRestaurantReviewUseCase class
  group('EditRestaurantReviewUseCase', () {
    test('should return a string when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockRestaurantReviewRepository.editRestaurantReview(
          editRestaurantReviewRequestModel:
              testEditRestaurantReview.editRestaurantReviewRequestModel,
        ),
      ).thenAnswer((_) async => const Right('Review added successfully'));
      // act
      final result =
          await editRestaurantReviewUseCase(testEditRestaurantReview);
      // assert
      expect(result, const Right('Review added successfully'));
      verify(
        mockRestaurantReviewRepository.editRestaurantReview(
          editRestaurantReviewRequestModel:
              testEditRestaurantReview.editRestaurantReviewRequestModel,
        ),
      );
      verifyNoMoreInteractions(mockRestaurantReviewRepository);
    });
  });
}
