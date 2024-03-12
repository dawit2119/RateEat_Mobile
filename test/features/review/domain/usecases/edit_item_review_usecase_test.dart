import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/edit_item_review_usecase.dart';

import 'add_item_review_usecase_test.mocks.dart';

void main() {
  late EditItemReviewUseCase editItemReviewUseCase;
  late MockItemReviewRepository mockItemReviewRepository;

  setUp(() {
    mockItemReviewRepository = MockItemReviewRepository();
    editItemReviewUseCase = EditItemReviewUseCase(
      repository: mockItemReviewRepository,
    );
  });

  final testEditItemReview = EditItemReviewUseCaseParams(
    editItemReviewRequestModel: EditItemReviewRequestModel(
      itemId: '1',
      reviewId: 'review',
      rating: 5,
    ),
  );

  // Test the EditItemReviewUseCase class
  group('EditItemReviewUseCase', () {
    test('should return a string when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockItemReviewRepository.editItemReview(
          editItemReviewRequestModel:
              testEditItemReview.editItemReviewRequestModel,
        ),
      ).thenAnswer((_) async => const Right('Review added successfully'));
      // act
      final result = await editItemReviewUseCase(testEditItemReview);
      // assert
      expect(result, const Right('Review added successfully'));
      verify(
        mockItemReviewRepository.editItemReview(
          editItemReviewRequestModel:
              testEditItemReview.editItemReviewRequestModel,
        ),
      );
      verifyNoMoreInteractions(mockItemReviewRepository);
    });
  });
}
