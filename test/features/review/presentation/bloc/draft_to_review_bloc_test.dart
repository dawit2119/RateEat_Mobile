import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/send_draft_to_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/draft_to_review/draft_to_review_bloc.dart';

import 'draft_to_review_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SendDraftToReviewUSeCase>(),
])
void main() {
  late DraftToReviewBloc draftToReviewBloc;
  late MockSendDraftToReviewUSeCase mockSendDraftToReviewUSeCase;

  setUp(() {
    mockSendDraftToReviewUSeCase = MockSendDraftToReviewUSeCase();
    draftToReviewBloc = DraftToReviewBloc(
      sendDraftToReviewUSeCase: mockSendDraftToReviewUSeCase,
    );
  });

  const testMessage = 'testMessage';
  final testDraftToReviewRequestModel = DraftToReviewRequestModel(
    draftItemReviewId: 'testDraftId',
    itemId: 'testItemId',
  );

  final params = SendDraftToReviewUSeCaseParams(
    draftToReviewRequestModel: testDraftToReviewRequestModel,
  );

  group('Draft To Review Bloc', () {
    test('initial state should be DraftToReviewInitial', () {
      // assert
      expect(draftToReviewBloc.state, DraftToReviewInitial());
    });
    blocTest<DraftToReviewBloc, DraftToReviewState>(
      'should emit [ DraftToReviewLoading, DraftToReviewSuccess] when SendDraftToReviewEvent is added.',
      build: () {
        when(
          mockSendDraftToReviewUSeCase(params),
        ).thenAnswer((_) async => const Right(testMessage));

        return draftToReviewBloc;
      },
      act: (bloc) => bloc.add(
        SendDraftToReviewEvent(
          draftToReviewRequest: testDraftToReviewRequestModel,
        ),
      ),
      expect: () => <DraftToReviewState>[
        DraftToReviewLoading(),
        DraftToReviewSuccess(message: testMessage),
      ],
    );

    blocTest<DraftToReviewBloc, DraftToReviewState>(
      'should emit [ DraftToReviewLoading, DraftToReviewFailure] when SendDraftToReviewEvent is added.',
      build: () {
        when(
          mockSendDraftToReviewUSeCase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: "Server Error")));

        return draftToReviewBloc;
      },
      act: (bloc) => bloc.add(
        SendDraftToReviewEvent(
          draftToReviewRequest: testDraftToReviewRequestModel,
        ),
      ),
      expect: () => <DraftToReviewState>[
        DraftToReviewLoading(),
        DraftToReviewFailure(message: "Server Error"),
      ],
    );
  });
}
