import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/entities/vote_on_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';

import '../../domain/use_cases/down_vote_restaurant_review.dart';
import '../../domain/use_cases/up_vote_restaurant_review.dart';
import '../../domain/use_cases/vote_on_review_param.dart';
import 'vote_on_review_event.dart';
import 'vote_on_review_state.dart';

class VoteOnReviewBloc extends Bloc<VoteOnReviewEvent, VoteOnReviewState> {
  final UpVoteItemReviewUseCase upVoteItemReviewUseCase;
  final DownVoteItemReviewUseCase downVoteItemReviewUseCase;
  final UpVoteRestaurantReviewUseCase upVoteRestaurantReviewUseCase;
  final DownVoteRestaurantReviewUseCase downVoteRestaurantReviewUseCase;
  VoteOnReviewBloc(super.initialState,
      {required this.upVoteItemReviewUseCase,
      required this.downVoteItemReviewUseCase,
      required this.upVoteRestaurantReviewUseCase,
      required this.downVoteRestaurantReviewUseCase,
      re}) {
    on<RegisterUpVoteOnReview>(_registerUpVote);
    on<RegisterDownVoteOnReview>(_registerDownVote);
    on<TriggerUpVote>(_triggerUpVote);
    on<TriggerDownVote>(_triggerDownVote);
  }

  _triggerUpVote(TriggerUpVote event, Emitter emit) {
    if (event.voteAction == VoteAction.add) {
      emit(
        VoteOnReviewPending(
          upVotes: state.upVotes + 1,
          downVotes: state.downVotes,
          flag: 1,
        ),
      );
    } else if (event.voteAction == VoteAction.remove) {
      emit(
        VoteOnReviewPending(
          upVotes: state.upVotes - 1,
          downVotes: state.downVotes,
          flag: 0,
        ),
      );
    }
  }

  _triggerDownVote(TriggerDownVote event, Emitter emit) {
    if (event.voteAction == VoteAction.add) {
      emit(
        VoteOnReviewPending(
          upVotes: state.upVotes,
          downVotes: state.downVotes + 1,
          flag: -1,
        ),
      );
    } else if (event.voteAction == VoteAction.remove) {
      emit(
        VoteOnReviewPending(
          upVotes: state.upVotes,
          downVotes: state.downVotes - 1,
          flag: 0,
        ),
      );
    }
  }

  _registerUpVote(RegisterUpVoteOnReview event, Emitter emit) async {
    late Either<Failure, VoteResponse> response;
    if (event.voteEntity == VoteEntity.item) {
      response = await upVoteItemReviewUseCase(VoteOnReviewParam(
        reviewId: event.reviewId,
        userId: event.userId,
      ));
    }
    if (event.voteEntity == VoteEntity.restaurant) {
      response = await upVoteRestaurantReviewUseCase(VoteOnReviewParam(
        reviewId: event.reviewId,
        userId: event.userId,
      ));
    }

    // Adding upvote completed and failed
    if (event.voteAction == VoteAction.add) {
      response.fold(
        (l) => emit(
          VoteOnReviewFailed(
            errorMessage: l.errorMessage,
            upVotes: event.prevState.upVotes,
            downVotes: event.prevState.downVotes,
            flag: event.prevState.flag,
          ),
        ),
        (r) => emit(
          VoteOnReviewSuccess(
            voteResponse: r,
            upVotes: r.review!.upVote ?? state.upVotes,
            downVotes: r.review!.downVote ?? state.downVotes,
            flag: r.review!.voted ?? state.flag,
          ),
        ),
      );
      // Removing upvote completed and failed
    } else if (event.voteAction == VoteAction.remove) {
      response.fold(
        (l) => emit(
          VoteOnReviewFailed(
            errorMessage: l.errorMessage,
            upVotes: event.prevState.upVotes,
            downVotes: event.prevState.downVotes,
            flag: event.prevState.flag,
          ),
        ),
        (r) => emit(
          VoteOnReviewSuccess(
            voteResponse: r,
            upVotes: r.review!.upVote ?? state.upVotes,
            downVotes: r.review!.downVote ?? state.downVotes,
            flag: r.review!.voted ?? state.flag,
          ),
        ),
      );
    }
  }

  _registerDownVote(RegisterDownVoteOnReview event, Emitter emit) async {
    late Either<Failure, VoteResponse> response;
    if (event.voteEntity == VoteEntity.item) {
      response = await downVoteItemReviewUseCase(VoteOnReviewParam(
        reviewId: event.reviewId,
        userId: event.userId,
      ));
    }
    if (event.voteEntity == VoteEntity.restaurant) {
      response = await downVoteRestaurantReviewUseCase(VoteOnReviewParam(
        reviewId: event.reviewId,
        userId: event.userId,
      ));
    }

    // Adding downvote completed and failed
    if (event.voteAction == VoteAction.add) {
      response.fold(
        (l) => emit(
          VoteOnReviewFailed(
            errorMessage: l.errorMessage,
            upVotes: event.prevState.upVotes,
            downVotes: event.prevState.downVotes,
            flag: event.prevState.flag,
          ),
        ),
        (r) => emit(
          VoteOnReviewSuccess(
            voteResponse: r,
            upVotes: r.review!.upVote ?? state.upVotes,
            downVotes: r.review!.downVote ?? state.downVotes,
            flag: r.review!.voted ?? state.flag,
          ),
        ),
      );

      // Removing downvote completed and failed
    } else if (event.voteAction == VoteAction.remove) {
      response.fold(
        (l) => emit(
          VoteOnReviewFailed(
            errorMessage: l.errorMessage,
            upVotes: event.prevState.upVotes,
            downVotes: event.prevState.downVotes,
            flag: event.prevState.flag,
          ),
        ),
        (r) => emit(
          VoteOnReviewSuccess(
            voteResponse: r,
            upVotes: r.review!.upVote ?? state.upVotes,
            downVotes: r.review!.downVote ?? state.downVotes,
            flag: r.review!.voted ?? state.flag,
          ),
        ),
      );
    }
  }
}
