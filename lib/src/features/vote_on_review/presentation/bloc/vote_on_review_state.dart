import 'package:equatable/equatable.dart';

import '../../domain/entities/vote_on_review.dart';

class VoteOnReviewState extends Equatable {
  final int upVotes;
  final int downVotes;
  // Downvote = -1, Upvote = 1, No vote = 0
  final int flag;

  const VoteOnReviewState({
    required this.upVotes,
    required this.downVotes,
    required this.flag,
  });
  @override
  List<Object?> get props => [upVotes, downVotes, flag];
}

class VoteOnReviewInitial extends VoteOnReviewState {
  const VoteOnReviewInitial({
    required super.upVotes,
    required super.downVotes,
    required super.flag,
  });

  VoteOnReviewState copyWith({int? upVotes, int? downVotes, int? flag}) {
    return VoteOnReviewInitial(
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      flag: flag ?? this.flag,
    );
  }
}

class VoteOnReviewPending extends VoteOnReviewState {
  const VoteOnReviewPending({
    required super.upVotes,
    required super.downVotes,
    required super.flag,
  });
}

class VoteOnReviewFailed extends VoteOnReviewState {
  final String errorMessage;

  const VoteOnReviewFailed({
    required this.errorMessage,
    required super.upVotes,
    required super.downVotes,
    required super.flag,
  });
}

class VoteOnReviewSuccess extends VoteOnReviewState {
  final VoteResponse voteResponse;

  const VoteOnReviewSuccess({
    required this.voteResponse,
    required super.upVotes,
    required super.downVotes,
    required super.flag,
  });
}
