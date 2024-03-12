import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/entities/vote_on_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/repository/vote_on_review_repo.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/vote_on_review_param.dart';

import 'vote_usecase_test.mocks.dart';

class MockVoteOnReviewRepository extends Mock
    implements VoteOnReviewRepository {}

@GenerateMocks([MockVoteOnReviewRepository])
void main() {
  late DownVoteItemReviewUseCase downVoteItemReviewUseCase;
  late DownVoteRestaurantReviewUseCase downVoteRestaurantReviewUseCase;
  late MockVoteOnReviewRepository mockVoteOnReviewRepository;
  late UpVoteItemReviewUseCase upVoteItemReviewUseCase;
  late UpVoteRestaurantReviewUseCase upVoteRestaurantReviewUseCase;
  setUp(() {
    mockVoteOnReviewRepository = MockMockVoteOnReviewRepository();
    downVoteItemReviewUseCase = DownVoteItemReviewUseCase(
        voteOnReviewRepository: mockVoteOnReviewRepository);
    downVoteRestaurantReviewUseCase = DownVoteRestaurantReviewUseCase(
        voteOnReviewRepository: mockVoteOnReviewRepository);
    upVoteItemReviewUseCase = UpVoteItemReviewUseCase(
        voteOnReviewRepository: mockVoteOnReviewRepository);
    upVoteRestaurantReviewUseCase = UpVoteRestaurantReviewUseCase(
        voteOnReviewRepository: mockVoteOnReviewRepository);
  });
  group('DownVoteItemReviewUseCase', () {
    test('should return a VoteResponse when downvoting is successful',
        () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      const voteResponse = VoteResponse(); // Create a mock VoteResponse object
      when(mockVoteOnReviewRepository.downVoteItemReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => const Right(
              voteResponse)); // Return a Right(Either) containing the voteResponse

      // Act
      final result = await downVoteItemReviewUseCase
          .call(VoteOnReviewParam(reviewId: reviewId, userId: userId));

      // Assert
      expect(result, const Right(voteResponse));
      verify(mockVoteOnReviewRepository.downVoteItemReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewRepository);
    });

    test('should return a ServerFailure when downvoting fails', () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      final error = ServerFailure(); // Create a mock ServerFailure object
      when(mockVoteOnReviewRepository.downVoteItemReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async =>
              Left(error)); // Return a Left(Either) containing the error

      // Act
      final result = await downVoteItemReviewUseCase
          .call(VoteOnReviewParam(reviewId: reviewId, userId: userId));

      // Assert
      expect(result, Left(error));
      verify(mockVoteOnReviewRepository.downVoteItemReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewRepository);
    });
  });

  group('DownVoteRestaurantReviewUseCase', () {
    test(
        'should return a VoteResponse when downvoting restaurant review is successful',
        () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      const voteResponse = VoteResponse(); // Create a mock VoteResponse object
      when(mockVoteOnReviewRepository.downVoteRestaurantReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => const Right(
              voteResponse)); // Return a Right(Either) containing the voteResponse

      // Act
      final result = await downVoteRestaurantReviewUseCase
          .call(VoteOnReviewParam(reviewId: reviewId, userId: userId));

      // Assert
      expect(result, const Right(voteResponse));
      verify(mockVoteOnReviewRepository.downVoteRestaurantReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewRepository);
    });

    test(
        'should return a ServerFailure when downvoting restaurant review fails',
        () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      final error = ServerFailure(); // Create a mock ServerFailure object
      when(mockVoteOnReviewRepository.downVoteRestaurantReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async =>
              Left(error)); // Return a Left(Either) containing the error

      // Act
      final result = await downVoteRestaurantReviewUseCase
          .call(VoteOnReviewParam(reviewId: reviewId, userId: userId));

      // Assert
      expect(result, Left(error));
      verify(mockVoteOnReviewRepository.downVoteRestaurantReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewRepository);
    });
  });

  group('UpVoteItemReviewUseCase', () {
    test('should return a VoteResponse when upvoting item review is successful',
        () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      const voteResponse = VoteResponse(); // Create a mock VoteResponse object
      when(mockVoteOnReviewRepository.upVoteItemReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => const Right(
              voteResponse)); // Return a Right(Either) containing the voteResponse

      // Act
      final result = await upVoteItemReviewUseCase
          .call(VoteOnReviewParam(reviewId: reviewId, userId: userId));

      // Assert
      expect(result, const Right(voteResponse));
      verify(mockVoteOnReviewRepository.upVoteItemReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewRepository);
    });

    test('should return a ServerFailure when upvoting item review fails',
        () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      final error = ServerFailure(); // Create a mock ServerFailure object
      when(mockVoteOnReviewRepository.upVoteItemReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async =>
              Left(error)); // Return a Left(Either) containing the error

      // Act
      final result = await upVoteItemReviewUseCase
          .call(VoteOnReviewParam(reviewId: reviewId, userId: userId));

      // Assert
      expect(result, Left(error));
      verify(mockVoteOnReviewRepository.upVoteItemReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewRepository);
    });
  });

  group('UpVoteRestaurantReviewUseCase', () {
    test(
        'should return a VoteResponse when upvoting restaurant review is successful',
        () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      const voteResponse = VoteResponse(); // Create a mock VoteResponse object
      when(mockVoteOnReviewRepository.upVoteRestaurantReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => const Right(
              voteResponse)); // Return a Right(Either) containing the voteResponse

      // Act
      final result = await upVoteRestaurantReviewUseCase
          .call(VoteOnReviewParam(reviewId: reviewId, userId: userId));

      // Assert
      expect(result, const Right(voteResponse));
      verify(mockVoteOnReviewRepository.upVoteRestaurantReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewRepository);
    });

    test('should return a ServerFailure when upvoting restaurant review fails',
        () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      final error = ServerFailure(); // Create a mock ServerFailure object
      when(mockVoteOnReviewRepository.upVoteRestaurantReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async =>
              Left(error)); // Return a Left(Either) containing the error

      // Act
      final result = await upVoteRestaurantReviewUseCase
          .call(VoteOnReviewParam(reviewId: reviewId, userId: userId));

      // Assert
      expect(result, Left(error));
      verify(mockVoteOnReviewRepository.upVoteRestaurantReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewRepository);
    });
  });
}
