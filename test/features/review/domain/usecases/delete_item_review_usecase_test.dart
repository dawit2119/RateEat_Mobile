import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_item_review_usecase.dart';

import 'add_item_review_usecase_test.mocks.dart';

void main() {
  late DeleteItemReviewUseCase deleteItemReviewUseCase;
  late MockItemReviewRepository mockItemReviewRepository;

  setUp(() {
    mockItemReviewRepository = MockItemReviewRepository();
    deleteItemReviewUseCase = DeleteItemReviewUseCase(
      repository: mockItemReviewRepository,
    );
  });

  final testDeleteItemReviewParams = DeleteItemReviewUseCaseParams(
    deleteItemReviewRequestModel: DeleteItemReviewRequestModel(
      itemId: '1',
      reviewId: 'reviewId',
    ),
  );

  group('DeleteItemReviewUseCase', () {
    test('should return a string when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockItemReviewRepository.deleteItemReview(
          deleteItemReviewRequestModel:
              testDeleteItemReviewParams.deleteItemReviewRequestModel,
        ),
      ).thenAnswer((_) async => const Right('Review deleted successfully'));
      // act
      final result = await deleteItemReviewUseCase(
        testDeleteItemReviewParams,
      );
      // assert
      expect(result, const Right('Review deleted successfully'));
      verify(
        mockItemReviewRepository.deleteItemReview(
          deleteItemReviewRequestModel:
              testDeleteItemReviewParams.deleteItemReviewRequestModel,
        ),
      );
      verifyNoMoreInteractions(mockItemReviewRepository);
    });
  });
}
