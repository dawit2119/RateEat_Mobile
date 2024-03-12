import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/send_draft_to_review_usecase.dart';

import 'add_item_review_usecase_test.mocks.dart';

void main() {
  late SendDraftToReviewUSeCase sendDraftToReviewUSeCase;
  late MockItemReviewRepository mockItemReviewRepository;

  setUp(() {
    mockItemReviewRepository = MockItemReviewRepository();
    sendDraftToReviewUSeCase = SendDraftToReviewUSeCase(
      repository: mockItemReviewRepository,
    );
  });

  final testSendDraftToReview = SendDraftToReviewUSeCaseParams(
    draftToReviewRequestModel: DraftToReviewRequestModel(
      itemId: '1',
      draftItemReviewId: 'review',
      rating: 5,
    ),
  );

  // Test the SendDraftToReviewUSeCase class
  group('SendDraftToReviewUSeCase', () {
    test('should return a string when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockItemReviewRepository.addDraftToReview(
          draftToReviewRequestModel:
              testSendDraftToReview.draftToReviewRequestModel,
        ),
      ).thenAnswer((_) async => const Right('Review added successfully'));
      // act
      final result = await sendDraftToReviewUSeCase(testSendDraftToReview);
      // assert
      expect(result, const Right('Review added successfully'));
      verify(
        mockItemReviewRepository.addDraftToReview(
          draftToReviewRequestModel:
              testSendDraftToReview.draftToReviewRequestModel,
        ),
      );
      verifyNoMoreInteractions(mockItemReviewRepository);
    });
  });
}
