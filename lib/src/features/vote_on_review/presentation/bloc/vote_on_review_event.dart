import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_state.dart';

class VoteOnReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterUpVoteOnReview extends VoteOnReviewEvent {
  final String userId;
  final String reviewId;
  final VoteAction voteAction;
  final VoteEntity voteEntity;
  final VoteOnReviewState prevState;

  RegisterUpVoteOnReview({
    required this.userId,
    required this.reviewId,
    required this.voteAction,
    required this.voteEntity,
    required this.prevState,
  });

  @override
  List<Object?> get props => [];
}

class RegisterDownVoteOnReview extends VoteOnReviewEvent {
  final String userId;
  final String reviewId;
  final VoteAction voteAction;
  final VoteEntity voteEntity;
  final VoteOnReviewState prevState;

  RegisterDownVoteOnReview({
    required this.userId,
    required this.reviewId,
    required this.voteAction,
    required this.voteEntity,
    required this.prevState,
  });

  @override
  List<Object?> get props => [];
}

class TriggerUpVote extends VoteOnReviewEvent {
  final VoteAction voteAction;

  TriggerUpVote({required this.voteAction});
}

class TriggerDownVote extends VoteOnReviewEvent {
  final VoteAction voteAction;

  TriggerDownVote({required this.voteAction});
}

enum VoteAction {
  add,
  remove,
}

enum VoteEntity {
  item,
  restaurant,
}
