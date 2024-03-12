import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_draft_review_usecase.dart';

import 'add_item_review_usecase_test.mocks.dart';

void main() {
  late DeleteDraftItemReviewUseCase deleteDraftItemReviewUseCase;
  late MockItemReviewRepository mockItemReviewRepository;

  setUp(() {
    mockItemReviewRepository = MockItemReviewRepository();
    deleteDraftItemReviewUseCase = DeleteDraftItemReviewUseCase(
      repository: mockItemReviewRepository,
    );
  });

  final testDeleteDraftItemReviewParams = DeleteDraftItemReviewUseCaseParams(
    deleteDraftItemReviewRequestModel: DeleteDraftItemReviewRequestModel(
      itemId: '1',
      draftItemReviewId: 'draftId',
    ),
  );

  group('DeleteDraftItemReviewUseCase', () {
    test('should return a string when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockItemReviewRepository.deleteDraftItemReview(
          deleteDraftItemReviewRequestModel:
              testDeleteDraftItemReviewParams.deleteDraftItemReviewRequestModel,
        ),
      ).thenAnswer((_) async => const Right('Review deleted successfully'));
      // act
      final result = await deleteDraftItemReviewUseCase(
        testDeleteDraftItemReviewParams,
      );
      // assert
      expect(result, const Right('Review deleted successfully'));
      verify(
        mockItemReviewRepository.deleteDraftItemReview(
          deleteDraftItemReviewRequestModel:
              testDeleteDraftItemReviewParams.deleteDraftItemReviewRequestModel,
        ),
      );
      verifyNoMoreInteractions(mockItemReviewRepository);
    });
  });
}
