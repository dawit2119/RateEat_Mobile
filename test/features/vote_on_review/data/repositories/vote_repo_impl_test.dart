import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/data/data_sources/review_vote_dp.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/data/repository/vote_on_review_impl.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/entities/vote_on_review.dart';

import 'vote_repo_impl_test.mocks.dart';

class MockVoteOnReviewDataProvider extends Mock
    implements VoteOnReviewDataProvider {}

@GenerateMocks([MockVoteOnReviewDataProvider])
void main() {
  late VoteOnReviewRepoImpl voteOnReviewRepoImpl;
  late MockVoteOnReviewDataProvider mockVoteOnReviewDataProvider;

  setUp(() {
    mockVoteOnReviewDataProvider = MockMockVoteOnReviewDataProvider();
    voteOnReviewRepoImpl = VoteOnReviewRepoImpl(
        voteOnReviewDataProvider: mockVoteOnReviewDataProvider);
  });

  group('upVoteItemReview', () {
    test('should return a VoteResponse when upvoting is successful', () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      const voteResponse = VoteResponse();
      when(mockVoteOnReviewDataProvider.upVoteItemReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => const Right(voteResponse));

      // Act
      final result = await voteOnReviewRepoImpl.upVoteItemReview(
          reviewId: reviewId, userId: userId);

      // Assert
      expect(result, const Right(voteResponse));
      verify(mockVoteOnReviewDataProvider.upVoteItemReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewDataProvider);
    });

    test('should return a ServerFailure when upvoting fails', () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      final error = ServerFailure();
      when(mockVoteOnReviewDataProvider.upVoteItemReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => Left(error));

      // Act
      final result = await voteOnReviewRepoImpl.upVoteItemReview(
          reviewId: reviewId, userId: userId);

      // Assert
      expect(result, Left(error));
      verify(mockVoteOnReviewDataProvider.upVoteItemReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewDataProvider);
    });
  });

  group('downVoteItemReview', () {
    test('should return a VoteResponse when downvoting is successful',
        () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      const voteResponse = VoteResponse();
      when(mockVoteOnReviewDataProvider.downVoteItemReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => const Right(voteResponse));

      // Act
      final result = await voteOnReviewRepoImpl.downVoteItemReview(
          reviewId: reviewId, userId: userId);

      // Assert
      expect(result, const Right(voteResponse));
      verify(mockVoteOnReviewDataProvider.downVoteItemReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewDataProvider);
    });

    test('should return a ServerFailure when downvoting fails', () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      final error = ServerFailure();
      when(mockVoteOnReviewDataProvider.downVoteItemReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => Left(error));

      // Act
      final result = await voteOnReviewRepoImpl.downVoteItemReview(
          reviewId: reviewId, userId: userId);

      // Assert
      expect(result, Left(ServerFailure(errorMessage: error.errorMessage)));
      verify(mockVoteOnReviewDataProvider.downVoteItemReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewDataProvider);
    });
  });

  group('upVoteRestaurantReview', () {
    test('should return a VoteResponse when upvoting is successful', () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      const voteResponse = VoteResponse();
      when(mockVoteOnReviewDataProvider.upVoteRestaurantReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => const Right(voteResponse));

      // Act
      final result = await voteOnReviewRepoImpl.upVoteRestaurantReview(
          reviewId: reviewId, userId: userId);

      // Assert
      expect(result, const Right(voteResponse));
      verify(mockVoteOnReviewDataProvider.upVoteRestaurantReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewDataProvider);
    });

    test('should return a ServerFailure when upvoting fails', () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      final error = ServerFailure();
      when(mockVoteOnReviewDataProvider.upVoteRestaurantReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => Left(error));

      // Act
      final result = await voteOnReviewRepoImpl.upVoteRestaurantReview(
          reviewId: reviewId, userId: userId);

      // Assert
      expect(result, Left(ServerFailure(errorMessage: error.errorMessage)));
      verify(mockVoteOnReviewDataProvider.upVoteRestaurantReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewDataProvider);
    });
  });

  group('downVoteRestaurantReview', () {
    test('should return a VoteResponse when downvoting is successful',
        () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      const voteResponse = VoteResponse();
      when(mockVoteOnReviewDataProvider.downVoteRestaurantReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => right(voteResponse));

      // Act
      final result = await voteOnReviewRepoImpl.downVoteRestaurantReview(
          reviewId: reviewId, userId: userId);

      // Assert
      expect(result, const Right(voteResponse));
      verify(mockVoteOnReviewDataProvider.downVoteRestaurantReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewDataProvider);
    });

    test('should return a ServerFailure when downvoting fails', () async {
      // Arrange
      const reviewId = '123';
      const userId = '456';
      final error = ServerFailure();
      when(mockVoteOnReviewDataProvider.downVoteRestaurantReview(
              reviewId: reviewId, userId: userId))
          .thenAnswer((_) async => Left(error));
      // Act
      final result = await voteOnReviewRepoImpl.downVoteRestaurantReview(
          reviewId: reviewId, userId: userId);

      // Assert
      expect(result, Left(ServerFailure(errorMessage: error.errorMessage)));
      verify(mockVoteOnReviewDataProvider.downVoteRestaurantReview(
          reviewId: reviewId, userId: userId));
      verifyNoMoreInteractions(mockVoteOnReviewDataProvider);
    });
  });
}
