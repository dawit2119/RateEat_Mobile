import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/flag_review.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/flag_review.dart';

import 'add_item_review_usecase_test.mocks.dart';

void main() {
  late FlagReviewUseCase flagReviewUseCase;
  late MockItemReviewRepository mockItemReviewRepository;

  setUp(() {
    mockItemReviewRepository = MockItemReviewRepository();
    flagReviewUseCase = FlagReviewUseCase(
      itemReviewRepository: mockItemReviewRepository,
    );
  });

  const testFlagReview = FlagReviewUseCaseParams(
    review: FlagReview(
      reviewId: '1',
      reportType: '',
      userId: '1',
    ),
  );

  // Test the FlagReviewUseCase class
  group('FlagReviewUseCase', () {
    test('should return a string when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockItemReviewRepository.flagReview(
          review: testFlagReview.review,
        ),
      ).thenAnswer((_) async => const Right('Review flagged successfully'));
      // act
      final result = await flagReviewUseCase(testFlagReview);
      // assert
      expect(result, const Right('Review flagged successfully'));
      verify(
        mockItemReviewRepository.flagReview(
          review: testFlagReview.review,
        ),
      );
      verifyNoMoreInteractions(mockItemReviewRepository);
    });
  });
}
