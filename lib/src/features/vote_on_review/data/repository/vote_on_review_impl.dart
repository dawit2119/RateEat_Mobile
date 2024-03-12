import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/repository/vote_on_review_repo.dart';

import '../../../../core/core.dart';
import '../../domain/entities/vote_on_review.dart';
import '../data_sources/review_vote_dp.dart';

class VoteOnReviewRepoImpl extends VoteOnReviewRepository {
  final VoteOnReviewDataProvider voteOnReviewDataProvider;

  VoteOnReviewRepoImpl({required this.voteOnReviewDataProvider});
  @override
  Future<Either<Failure, VoteResponse>> upVoteItemReview(
      {required String reviewId, required String userId}) async {
    return await voteOnReviewDataProvider.upVoteItemReview(
      reviewId: reviewId,
      userId: userId,
    );
  }

  @override
  Future<Either<Failure, VoteResponse>> downVoteItemReview(
      {required String reviewId, required String userId}) async {
    return await voteOnReviewDataProvider.downVoteItemReview(
      reviewId: reviewId,
      userId: userId,
    );
  }

  @override
  Future<Either<Failure, VoteResponse>> upVoteRestaurantReview(
      {required String reviewId, required String userId}) async {
    return await voteOnReviewDataProvider.upVoteRestaurantReview(
      reviewId: reviewId,
      userId: userId,
    );
  }

  @override
  Future<Either<Failure, VoteResponse>> downVoteRestaurantReview(
      {required String reviewId, required String userId}) async {
    return await voteOnReviewDataProvider.downVoteRestaurantReview(
      reviewId: reviewId,
      userId: userId,
    );
  }
}
