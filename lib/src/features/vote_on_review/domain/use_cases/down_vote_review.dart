import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/entities/vote_on_review.dart';

import '../../../../core/core.dart';
import '../repository/vote_on_review_repo.dart';
import 'vote_on_review_param.dart';

class DownVoteReviewUseCase extends UseCase<VoteResponse, VoteOnReviewParam> {
  final VoteOnReviewRepository voteOnReviewRepository;

  DownVoteReviewUseCase({required this.voteOnReviewRepository});

  @override
  Future<Either<Failure, VoteResponse>> call(VoteOnReviewParam params) async {
    return await voteOnReviewRepository.downVoteItemReview(
      reviewId: params.reviewId,
      userId: params.userId,
    );
  }
}
