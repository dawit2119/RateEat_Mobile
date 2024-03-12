import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_item_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';

import 'delete_item_review_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DeleteItemReviewUseCase>(),
])
void main() {
  late DeleteItemReviewBloc deleteItemReviewBloc;
  late MockDeleteItemReviewUseCase mockDeleteItemReviewUseCase;

  setUp(() {
    mockDeleteItemReviewUseCase = MockDeleteItemReviewUseCase();
    deleteItemReviewBloc = DeleteItemReviewBloc(
      deleteItemReviewUseCase: mockDeleteItemReviewUseCase,
    );
  });

  const testMessage = 'testMessage';
  final testDeleteItemReviewRequestModel = DeleteItemReviewRequestModel(
    itemId: 'testItemId',
    reviewId: 'testReviewId',
  );

  final params = DeleteItemReviewUseCaseParams(
    deleteItemReviewRequestModel: testDeleteItemReviewRequestModel,
  );

  group('Delete Item Review Bloc', () {
    test('initial state should be DeleteItemReviewInitial', () {
      // assert
      expect(deleteItemReviewBloc.state, DeleteItemReviewInitial());
    });

    blocTest<DeleteItemReviewBloc, DeleteItemReviewState>(
      'should emit [ DeleteItemReviewLoading, DeleteItemReviewSuccess] when DeleteItemReviewRequestEvent is added.',
      build: () {
        when(
          mockDeleteItemReviewUseCase(params),
        ).thenAnswer((_) async => const Right(testMessage));

        return deleteItemReviewBloc;
      },
      act: (bloc) => bloc.add(
        DeleteItemReviewRequestEvent(
          deleteItemReviewRequestModel: testDeleteItemReviewRequestModel,
        ),
      ),
      expect: () => <DeleteItemReviewState>[
        DeleteItemReviewLoading(),
        const DeleteItemReviewSuccess(message: testMessage),
      ],
    );

    blocTest<DeleteItemReviewBloc, DeleteItemReviewState>(
      'should emit [ DeleteItemReviewLoading, DeleteItemReviewFailure] when DeleteItemReviewRequestEvent is added.',
      build: () {
        when(
          mockDeleteItemReviewUseCase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

        return deleteItemReviewBloc;
      },
      act: (bloc) => bloc.add(
        DeleteItemReviewRequestEvent(
          deleteItemReviewRequestModel: testDeleteItemReviewRequestModel,
        ),
      ),
      expect: () => <DeleteItemReviewState>[
        DeleteItemReviewLoading(),
        const DeleteItemReviewFailure(message: 'Server Error'),
      ],
    );
  });
}
