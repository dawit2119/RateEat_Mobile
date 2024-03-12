import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/settings/domain/usecase/feedbackusecase.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_bloc.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_event.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_state.dart';

import 'give_feedback_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FeedbackUseCase>(),
])
void main() {
  late MockFeedbackUseCase mockFeedbackUseCase;
  late FeedbackBloc feedbackBloc;

  setUp(() {
    mockFeedbackUseCase = MockFeedbackUseCase();
    feedbackBloc = FeedbackBloc(
      feedbackUseCase: mockFeedbackUseCase,
    );
  });

  group("Feedback bloc should save the feedback and return the saved comment",
      () {
    const comment = "comment";
    test("Initial state must be FeedbackInitial", () {
      expect(
        feedbackBloc.state,
        FeedbackInitial(),
      );
    });
    blocTest<FeedbackBloc, FeedbackState>(
        "Feedback bloc should emit[FeedbackLoading(),FeedbackSuccess()]",
        build: () {
          when(
            mockFeedbackUseCase.giveFeedback(comment),
          ).thenAnswer(
            (_) async => const Right(comment),
          );
          return feedbackBloc;
        },
        act: (bloc) => bloc.add(
              SubmitFeedbackEvent(comment: comment),
            ),
        expect: () => <FeedbackState>[
              FeedbackLoading(),
              FeedbackSuccess(
                message: comment,
              ),
            ]);

    blocTest<FeedbackBloc, FeedbackState>(
        'emits [FeedBackLoading, FeedbackError] on SubmmitedFeedBackEvent',
        build: () {
          when(mockFeedbackUseCase.giveFeedback(comment)).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'Server Failure')));
          return feedbackBloc;
        },
        act: (bloc) => bloc.add(SubmitFeedbackEvent(comment: comment)),
        expect: () => [
              FeedbackLoading(),
              isA<FeedbackFailure>(),
            ]);
  });
}
