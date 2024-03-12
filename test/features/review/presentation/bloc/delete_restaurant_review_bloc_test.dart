import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_restaurant_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';

import 'delete_restaurant_review_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DeleteRestaurantReviewUseCase>(),
])
void main() {
  late DeleteRestaurantReviewBloc deleteRestaurantReviewBloc;
  late MockDeleteRestaurantReviewUseCase mockDeleteRestaurantReviewUseCase;

  setUp(() {
    mockDeleteRestaurantReviewUseCase = MockDeleteRestaurantReviewUseCase();
    deleteRestaurantReviewBloc = DeleteRestaurantReviewBloc(
      deleteRestaurantReviewUseCase: mockDeleteRestaurantReviewUseCase,
    );
  });

  const testMessage = 'testMessage';
  final testDeleteRestaurantReviewRequestModel =
      DeleteRestaurantReviewRequestModel(
    restaurantId: 'testRestaurantId',
    reviewId: 'reviewId',
  );

  final params = DeleteRestaurantReviewUseCaseParams(
    deleteRestaurantReviewRequestModel: testDeleteRestaurantReviewRequestModel,
  );
  group('Delete Restaurant Review Bloc', () {
    test('initial state should be DeleteRestaurantReviewInitial', () {
      // assert
      expect(deleteRestaurantReviewBloc.state, DeleteRestaurantReviewInitial());
    });
    blocTest<DeleteRestaurantReviewBloc, DeleteRestaurantReviewState>(
      'should emit [ DeleteRestaurantReviewLoading, DeleteRestaurantReviewSuccess] when DeleteRestaurantReviewRequestEvent is added.',
      build: () {
        when(
          mockDeleteRestaurantReviewUseCase(
            params,
          ),
        ).thenAnswer((_) async => const Right(testMessage));

        return deleteRestaurantReviewBloc;
      },
      act: (bloc) => bloc.add(
        DeleteRestaurantReviewRequestEvent(
          deleteRestaurantReviewRequestModel:
              testDeleteRestaurantReviewRequestModel,
        ),
      ),
      expect: () => <DeleteRestaurantReviewState>[
        DeleteRestaurantReviewLoading(),
        const DeleteRestaurantReviewSuccess(message: testMessage),
      ],
    );

    blocTest<DeleteRestaurantReviewBloc, DeleteRestaurantReviewState>(
      'should emit [ DeleteRestaurantReviewLoading, DeleteRestaurantReviewFailure] when DeleteRestaurantReviewRequestEvent is added.',
      build: () {
        when(
          mockDeleteRestaurantReviewUseCase(
            params,
          ),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

        return deleteRestaurantReviewBloc;
      },
      act: (bloc) => bloc.add(
        DeleteRestaurantReviewRequestEvent(
          deleteRestaurantReviewRequestModel:
              testDeleteRestaurantReviewRequestModel,
        ),
      ),
      expect: () => <DeleteRestaurantReviewState>[
        DeleteRestaurantReviewLoading(),
        const DeleteRestaurantReviewFailure(message: 'Server Error'),
      ],
    );
  });
}
