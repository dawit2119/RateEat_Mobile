import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_draft_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_draft_review/delete_draft_review_bloc.dart';

import 'delete_draft_review_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DeleteDraftItemReviewUseCase>(),
])
void main() {
  late DeleteDraftReviewBloc deleteDraftReviewBloc;
  late MockDeleteDraftItemReviewUseCase mockDeleteDraftItemReviewUseCase;

  setUp(() {
    mockDeleteDraftItemReviewUseCase = MockDeleteDraftItemReviewUseCase();
    deleteDraftReviewBloc = DeleteDraftReviewBloc(
      deleteDraftItemReviewUseCase: mockDeleteDraftItemReviewUseCase,
    );
  });

  const testMessage = 'testMessage';
  final testDeleteDraftItemReviewRequestModel =
      DeleteDraftItemReviewRequestModel(
    draftItemReviewId: 'testReviewId',
    itemId: 'testItemId',
  );
  final params = DeleteDraftItemReviewUseCaseParams(
    deleteDraftItemReviewRequestModel: testDeleteDraftItemReviewRequestModel,
  );

  group('Delete Draft Review Bloc', () {
    test('initial state should be DeleteDraftItemReviewInitial', () {
      // assert
      expect(deleteDraftReviewBloc.state, DeleteDraftItemReviewInitial());
    });
    blocTest<DeleteDraftReviewBloc, DeleteDraftReviewState>(
      'should emit [ DeleteDraftItemReviewLoading, DeleteDraftItemReviewSuccess] when DeleteDraftItemReviewRequestEvent is added.',
      build: () {
        when(
          mockDeleteDraftItemReviewUseCase(params),
        ).thenAnswer((_) async => const Right(testMessage));

        return deleteDraftReviewBloc;
      },
      act: (bloc) => bloc.add(
        DeleteDraftItemReviewRequestEvent(
          deleteDraftItemReviewRequestModel:
              testDeleteDraftItemReviewRequestModel,
        ),
      ),
      expect: () => <DeleteDraftReviewState>[
        DeleteDraftItemReviewLoading(),
        DeleteDraftItemReviewSuccess(message: testMessage),
      ],
    );

    blocTest<DeleteDraftReviewBloc, DeleteDraftReviewState>(
      'should emit [ DeleteDraftItemReviewLoading, DeleteDraftItemReviewFailure] when DeleteDraftItemReviewRequestEvent is added.',
      build: () {
        when(
          mockDeleteDraftItemReviewUseCase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

        return deleteDraftReviewBloc;
      },
      act: (bloc) => bloc.add(
        DeleteDraftItemReviewRequestEvent(
          deleteDraftItemReviewRequestModel:
              testDeleteDraftItemReviewRequestModel,
        ),
      ),
      expect: () => <DeleteDraftReviewState>[
        DeleteDraftItemReviewLoading(),
        DeleteDraftItemReviewFailure(message: 'Server Error'),
      ],
    );
  });
}
