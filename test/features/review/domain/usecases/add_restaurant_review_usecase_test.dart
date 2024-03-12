import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/restaurant_review_repository.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/add_restaurant_review_usecase.dart';

import 'add_restaurant_review_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RestaurantReviewRepository>(),
])
void main() {
  late AddRestaurantReviewUseCase addRestaurantReviewUseCase;
  late MockRestaurantReviewRepository mockRestaurantReviewRepository;

  setUp(() {
    mockRestaurantReviewRepository = MockRestaurantReviewRepository();
    addRestaurantReviewUseCase = AddRestaurantReviewUseCase(
      repository: mockRestaurantReviewRepository,
    );
  });

  final testRestaurantModel = AddRestaurantReviewRequestModel(
    restaurantId: '1',
    rating: 4,
  );
  // Test the AddRestaurantReviewUseCase class
  group('AddRestaurantReviewUseCase', () {
    test('should return a string when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockRestaurantReviewRepository.addRestaurantReview(
          addRestaurantReviewRequestModel:
              anyNamed('addRestaurantReviewRequestModel'),
        ),
      ).thenAnswer((_) async => const Right('Review added successfully'));
      // act
      final result = await addRestaurantReviewUseCase.call(
        AddRestaurantReviewUseCaseParams(
          addRestaurantReviewRequestModel: testRestaurantModel,
        ),
      );
      // assert
      expect(result, const Right('Review added successfully'));
      verify(
        mockRestaurantReviewRepository.addRestaurantReview(
          addRestaurantReviewRequestModel: testRestaurantModel,
        ),
      );
      verifyNoMoreInteractions(mockRestaurantReviewRepository);
    });
  });
}
