import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/edit_item_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/edit_item_review/edit_item_review_bloc.dart';

import 'edit_item_review_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<EditItemReviewUseCase>(),
])
void main() {
  late EditItemReviewBloc editItemReviewBloc;
  late MockEditItemReviewUseCase mockEditItemReviewUseCase;

  setUp(() {
    mockEditItemReviewUseCase = MockEditItemReviewUseCase();
    editItemReviewBloc = EditItemReviewBloc(
      editItemReviewUseCase: mockEditItemReviewUseCase,
    );
  });

  const testMessage = 'testMessage';
  final testEditItemReviewRequestModel = EditItemReviewRequestModel(
    itemId: 'testItemId',
    reviewId: 'testReviewId',
    rating: 5,
    comment: 'testComment',
  );

  final params = EditItemReviewUseCaseParams(
    editItemReviewRequestModel: testEditItemReviewRequestModel,
  );

  group('Edit Item Review Bloc', () {
    test('initial state should be EditItemReviewInitial', () {
      // assert
      expect(editItemReviewBloc.state, EditItemReviewInitial());
    });

    blocTest<EditItemReviewBloc, EditItemReviewState>(
      'should emit [ EditItemReviewLoading, EditItemReviewSuccess] when EditItemReviewRequestEvent is added.',
      build: () {
        when(
          mockEditItemReviewUseCase(params),
        ).thenAnswer((_) async => const Right(testMessage));

        return editItemReviewBloc;
      },
      act: (bloc) => bloc.add(
        EditItemReviewRequestEvent(
          editItemReviewRequest: testEditItemReviewRequestModel,
        ),
      ),
      expect: () => <EditItemReviewState>[
        EditItemReviewLoading(),
        const EditItemReviewSuccess(message: testMessage),
      ],
    );

    blocTest<EditItemReviewBloc, EditItemReviewState>(
      'should emit [ EditItemReviewLoading, EditItemReviewFailure] when EditItemReviewRequestEvent is added.',
      build: () {
        when(
          mockEditItemReviewUseCase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

        return editItemReviewBloc;
      },
      act: (bloc) => bloc.add(
        EditItemReviewRequestEvent(
          editItemReviewRequest: testEditItemReviewRequestModel,
        ),
      ),
      expect: () => <EditItemReviewState>[
        EditItemReviewLoading(),
        const EditItemReviewFailure(message: 'Server Error'),
      ],
    );
  });
}
