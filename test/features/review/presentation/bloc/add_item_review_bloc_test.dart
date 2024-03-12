import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/add_item_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/add_item_review/add_item_review_bloc.dart';

import 'add_item_review_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AddItemReviewUseCase>(),
])
void main() {
  late AddItemReviewBloc addItemReviewBloc;
  late MockAddItemReviewUseCase mockAddItemReviewUseCase;

  setUp(() {
    mockAddItemReviewUseCase = MockAddItemReviewUseCase();
    addItemReviewBloc = AddItemReviewBloc(
      addItemReviewUseCase: mockAddItemReviewUseCase,
    );
  });

  final testAddItemReviewRequestModel = AddItemReviewRequestModel(
    itemId: 'testItemId',
    rating: 5,
  );
  final params = AddItemReviewUseCaseParams(
    addItemReviewRequestModel: testAddItemReviewRequestModel,
    isCandidateItem: false,
  );

  group('Add Item Review Bloc', () {
    test('initial state should be AddItemReviewInitial', () {
      // assert
      expect(addItemReviewBloc.state, AddItemReviewInitial());
    });
    blocTest<AddItemReviewBloc, AddItemReviewState>(
      'should emit [ AddItemReviewLoading, AddItemReviewSuccess] when AddItemReviewRequestEvent is added.',
      build: () {
        when(
          mockAddItemReviewUseCase(params),
        ).thenAnswer((_) async => const Right(true));

        return addItemReviewBloc;
      },
      act: (bloc) => bloc.add(
        AddItemReviewRequestEvent(
          addItemReviewRequest: testAddItemReviewRequestModel,
          isCandidateItem: false,
        ),
      ),
      expect: () => <AddItemReviewState>[
        AddItemReviewLoading(),
        AddItemReviewSuccess(),
      ],
    );

    blocTest<AddItemReviewBloc, AddItemReviewState>(
      'should emit [ AddItemReviewLoading, AddItemReviewFailure] when AddItemReviewRequestEvent is added.',
      build: () {
        when(
          mockAddItemReviewUseCase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

        return addItemReviewBloc;
      },
      act: (bloc) => bloc.add(
        AddItemReviewRequestEvent(
          addItemReviewRequest: testAddItemReviewRequestModel,
          isCandidateItem: false,
        ),
      ),
      expect: () => <AddItemReviewState>[
        AddItemReviewLoading(),
        const AddItemReviewFailure(message: 'Server Error'),
      ],
    );
  });
}
