import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/vote_on_review.dart';

abstract class VoteOnReviewRepository {
  Future<Either<Failure, VoteResponse>> upVoteItemReview({
    required String reviewId,
    required String userId,
  });
  Future<Either<Failure, VoteResponse>> downVoteItemReview({
    required String reviewId,
    required String userId,
  });
  Future<Either<Failure, VoteResponse>> upVoteRestaurantReview({
    required String reviewId,
    required String userId,
  });
  Future<Either<Failure, VoteResponse>> downVoteRestaurantReview({
    required String reviewId,
    required String userId,
  });
}
