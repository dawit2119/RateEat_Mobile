import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/entities/vote_on_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_bloc.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_item_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/up_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/down_vote_restaurant_review.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/use_cases/vote_on_review_param.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_event.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/presentation/bloc/vote_on_review_state.dart';

import 'vote_bloc_test.mocks.dart';

@GenerateMocks([
  UpVoteItemReviewUseCase,
  DownVoteItemReviewUseCase,
  UpVoteRestaurantReviewUseCase,
  DownVoteRestaurantReviewUseCase
])
void main() {
  late MockUpVoteItemReviewUseCase mockUpVoteItemReviewUseCase;
  late MockDownVoteItemReviewUseCase mockDownVoteItemReviewUseCase;
  late MockUpVoteRestaurantReviewUseCase mockUpVoteRestaurantReviewUseCase;
  late MockDownVoteRestaurantReviewUseCase mockDownVoteRestaurantReviewUseCase;
  late VoteOnReviewBloc voteOnReviewBloc;

  setUp(() {
    mockUpVoteItemReviewUseCase = MockUpVoteItemReviewUseCase();
    mockDownVoteItemReviewUseCase = MockDownVoteItemReviewUseCase();
    mockUpVoteRestaurantReviewUseCase = MockUpVoteRestaurantReviewUseCase();
    mockDownVoteRestaurantReviewUseCase = MockDownVoteRestaurantReviewUseCase();

    voteOnReviewBloc = VoteOnReviewBloc(
      const VoteOnReviewInitial(upVotes: 0, downVotes: 0, flag: 0),
      upVoteItemReviewUseCase: mockUpVoteItemReviewUseCase,
      downVoteItemReviewUseCase: mockDownVoteItemReviewUseCase,
      upVoteRestaurantReviewUseCase: mockUpVoteRestaurantReviewUseCase,
      downVoteRestaurantReviewUseCase: mockDownVoteRestaurantReviewUseCase,
    );
  });

  group('VoteOnReviewBlocItemUpvote', () {
    const userId = 'userId';
    const reviewId = 'reviewId';
    const prevState = VoteOnReviewInitial(upVotes: 0, downVotes: 0, flag: 0);
    final params = VoteOnReviewParam(reviewId: reviewId, userId: userId);
    final event = RegisterUpVoteOnReview(
      userId: userId,
      reviewId: reviewId,
      voteAction: VoteAction.add,
      voteEntity: VoteEntity.item,
      prevState: prevState,
    );

    const voteResponse = VoteResponse(
      review: ReviewOnVote(upVote: 1, downVote: 0, voted: 1),
    );

    test('emits [ VoteOnReviewSuccess] when upvote is successful', () async {
      when(mockUpVoteItemReviewUseCase.call(params))
          .thenAnswer((_) async => const Right(voteResponse));

      voteOnReviewBloc.add(event);

      await expectLater(
        voteOnReviewBloc.stream,
        emitsInOrder([
          const VoteOnReviewSuccess(
              voteResponse: voteResponse, upVotes: 1, downVotes: 0, flag: 1),
        ]),
      );
    });

    test('emits [ VoteOnReviewFailed] when upvote fails', () async {
      final failure = ServerFailure();
      when(mockUpVoteItemReviewUseCase.call(params))
          .thenAnswer((_) async => Left(failure));

      voteOnReviewBloc.add(event);

      await expectLater(
        voteOnReviewBloc.stream,
        emitsInOrder([
          VoteOnReviewFailed(
              errorMessage: failure.errorMessage,
              upVotes: 0,
              downVotes: 0,
              flag: 0),
        ]),
      );
    });
  });

  group('VoteOnReviewBlocItemDownVote', () {
    const userId = 'userId';
    const reviewId = 'reviewId';
    const prevState = VoteOnReviewInitial(upVotes: 0, downVotes: 0, flag: 0);
    final params = VoteOnReviewParam(reviewId: reviewId, userId: userId);
    final event = RegisterDownVoteOnReview(
      userId: userId,
      reviewId: reviewId,
      voteAction: VoteAction.remove,
      voteEntity: VoteEntity.item,
      prevState: prevState,
    );

    const voteResponse = VoteResponse(
      review: ReviewOnVote(upVote: 0, downVote: 1, voted: 1),
    );

    test('emits [ VoteOnReviewSuccess] when downvote is successful', () async {
      when(mockDownVoteItemReviewUseCase.call(params))
          .thenAnswer((_) async => const Right(voteResponse));

      voteOnReviewBloc.add(event);

      await expectLater(
        voteOnReviewBloc.stream,
        emitsInOrder([
          const VoteOnReviewSuccess(
              voteResponse: voteResponse, upVotes: 0, downVotes: 1, flag: 1),
        ]),
      );
    });

    test('emits [ VoteOnReviewFailed] when downvote fails', () async {
      final failure = ServerFailure(errorMessage: 'Downvote failed');
      when(mockDownVoteItemReviewUseCase.call(params))
          .thenAnswer((_) async => Left(failure));

      voteOnReviewBloc.add(event);

      await expectLater(
        voteOnReviewBloc.stream,
        emitsInOrder([
          VoteOnReviewFailed(
              errorMessage: failure.errorMessage,
              upVotes: 0,
              downVotes: 0,
              flag: 0),
        ]),
      );
    });
  });

  group('VoteOnReviewBlocRestaurantupvote', () {
    const userId = 'userId';
    const reviewId = 'reviewId';
    const prevState = VoteOnReviewInitial(upVotes: 0, downVotes: 0, flag: 0);
    final params = VoteOnReviewParam(reviewId: reviewId, userId: userId);
    final event = RegisterUpVoteOnReview(
      userId: userId,
      reviewId: reviewId,
      voteAction: VoteAction.add,
      voteEntity: VoteEntity.restaurant,
      prevState: prevState,
    );

    const voteResponse = VoteResponse(
      review: ReviewOnVote(upVote: 1, downVote: 0, voted: 1),
    );

    test(
        'emits [VoteOnReviewPending, VoteOnReviewSuccess] when upvote is successful',
        () async {
      when(mockUpVoteRestaurantReviewUseCase.call(params))
          .thenAnswer((_) async => const Right(voteResponse));

      voteOnReviewBloc.add(event);

      await expectLater(
        voteOnReviewBloc.stream,
        emitsInOrder([
          const VoteOnReviewSuccess(
              voteResponse: voteResponse, upVotes: 1, downVotes: 0, flag: 1),
        ]),
      );
    });

    test('emits [ VoteOnReviewFailed] when upvote fails', () async {
      final failure = ServerFailure(errorMessage: 'Upvote failed');
      when(mockUpVoteRestaurantReviewUseCase.call(params))
          .thenAnswer((_) async => Left(failure));

      voteOnReviewBloc.add(event);

      await expectLater(
        voteOnReviewBloc.stream,
        emitsInOrder([
          VoteOnReviewFailed(
              errorMessage: failure.errorMessage,
              upVotes: 0,
              downVotes: 0,
              flag: 0),
        ]),
      );
    });
  });

  group('VoteOnReviewBlocRestaurantDownVote', () {
    const userId = 'userId';
    const reviewId = 'reviewId';
    const prevState = VoteOnReviewInitial(upVotes: 0, downVotes: 0, flag: 0);
    final params = VoteOnReviewParam(reviewId: reviewId, userId: userId);
    final event = RegisterDownVoteOnReview(
      userId: userId,
      reviewId: reviewId,
      voteAction: VoteAction.remove,
      voteEntity: VoteEntity.restaurant,
      prevState: prevState,
    );

    const voteResponse = VoteResponse(
      review: ReviewOnVote(upVote: 0, downVote: 1, voted: 1),
    );

    test('emits [ VoteOnReviewSuccess] when downvote is successful', () async {
      when(mockDownVoteRestaurantReviewUseCase.call(params))
          .thenAnswer((_) async => const Right(voteResponse));

      voteOnReviewBloc.add(event);

      await expectLater(
        voteOnReviewBloc.stream,
        emitsInOrder([
          const VoteOnReviewSuccess(
              voteResponse: voteResponse, upVotes: 0, downVotes: 1, flag: 1),
        ]),
      );
    });

    test('emits [ VoteOnReviewFailed] when downvote fails', () async {
      final failure = ServerFailure(errorMessage: 'Downvote failed');
      when(mockDownVoteRestaurantReviewUseCase.call(params))
          .thenAnswer((_) async => Left(failure));

      voteOnReviewBloc.add(event);

      await expectLater(
        voteOnReviewBloc.stream,
        emitsInOrder([
          VoteOnReviewFailed(
              errorMessage: failure.errorMessage,
              upVotes: 0,
              downVotes: 0,
              flag: 0),
        ]),
      );
    });

    group('VoteOnReviewBlocTriggerUpVote', () {
      const prevState = VoteOnReviewInitial(upVotes: 0, downVotes: 0, flag: 0);

      test('emits [VoteOnReviewPending] when adding upvote', () async {
        final event = TriggerUpVote(voteAction: VoteAction.add);
        voteOnReviewBloc.emit(prevState);

        voteOnReviewBloc.add(event);

        await expectLater(
          voteOnReviewBloc.stream,
          emitsInOrder([
            VoteOnReviewPending(upVotes: 1, downVotes: 0, flag: 1),
          ]),
        );
      });

      test('emits [VoteOnReviewPending] when removing upvote', () async {
        final event = TriggerUpVote(voteAction: VoteAction.remove);
        voteOnReviewBloc.emit(prevState.copyWith(upVotes: 1));

        voteOnReviewBloc.add(event);

        await expectLater(
          voteOnReviewBloc.stream,
          emitsInOrder([
            VoteOnReviewPending(upVotes: 0, downVotes: 0, flag: 0),
          ]),
        );
      });
    });

    group('VoteOnReviewBlocTriggerDownVote', () {
      const prevState = VoteOnReviewInitial(upVotes: 0, downVotes: 0, flag: 0);

      test('emits [VoteOnReviewPending] when adding downvote', () async {
        final event = TriggerDownVote(voteAction: VoteAction.add);
        voteOnReviewBloc.emit(prevState);

        voteOnReviewBloc.add(event);

        await expectLater(
          voteOnReviewBloc.stream,
          emitsInOrder([
            VoteOnReviewPending(upVotes: 0, downVotes: 1, flag: -1),
          ]),
        );
      });

      test('emits [VoteOnReviewPending] when removing downvote', () async {
        final event = TriggerDownVote(voteAction: VoteAction.remove);
        voteOnReviewBloc.emit(prevState.copyWith(downVotes: 1));

        voteOnReviewBloc.add(event);

        await expectLater(
          voteOnReviewBloc.stream,
          emitsInOrder([
            VoteOnReviewPending(upVotes: 0, downVotes: 0, flag: 0),
          ]),
        );
      });
    });
  });
}
