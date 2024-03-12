import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/edit_restaurant_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/edit_restaurant_review/edit_restaurant_review_bloc.dart';

import 'edit_restaurant_review_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<EditRestaurantReviewUseCase>(),
])
void main() {
  late EditRestaurantReviewBloc editRestaurantReviewBloc;
  late MockEditRestaurantReviewUseCase mockEditRestaurantReviewUseCase;

  setUp(() {
    mockEditRestaurantReviewUseCase = MockEditRestaurantReviewUseCase();
    editRestaurantReviewBloc = EditRestaurantReviewBloc(
      editRestaurantReviewUseCase: mockEditRestaurantReviewUseCase,
    );
  });

  const testMessage = 'testMessage';
  final testEditRestaurantReviewRequestModel = EditRestaurantReviewRequestModel(
    restaurantId: 'testRestaurantId',
    reviewId: 'testReviewId',
    rating: 5,
    comment: 'testComment',
  );

  final params = EditRestaurantReviewUseCaseParams(
    editRestaurantReviewRequestModel: testEditRestaurantReviewRequestModel,
  );

  group('Edit Restaurant Review Bloc', () {
    test('initial state should be EditRestaurantReviewInitial', () {
      // assert
      expect(editRestaurantReviewBloc.state, EditRestaurantReviewInitial());
    });

    blocTest<EditRestaurantReviewBloc, EditRestaurantReviewState>(
      'should emit [ EditRestaurantReviewLoading, EditRestaurantReviewSuccess] when EditRestaurantReviewRequestEvent is added.',
      build: () {
        when(
          mockEditRestaurantReviewUseCase(params),
        ).thenAnswer((_) async => const Right(testMessage));

        return editRestaurantReviewBloc;
      },
      act: (bloc) => bloc.add(
        EditRestaurantReviewRequestEvent(
          editRestaurantReviewRequest: testEditRestaurantReviewRequestModel,
        ),
      ),
      expect: () => <EditRestaurantReviewState>[
        EditRestaurantReviewLoading(),
        const EditRestaurantReviewSuccess(message: testMessage),
      ],
    );

    blocTest<EditRestaurantReviewBloc, EditRestaurantReviewState>(
      'should emit [ EditRestaurantReviewLoading, EditRestaurantReviewFailure] when EditRestaurantReviewRequestEvent is added.',
      build: () {
        when(
          mockEditRestaurantReviewUseCase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

        return editRestaurantReviewBloc;
      },
      act: (bloc) => bloc.add(
        EditRestaurantReviewRequestEvent(
          editRestaurantReviewRequest: testEditRestaurantReviewRequestModel,
        ),
      ),
      expect: () => <EditRestaurantReviewState>[
        EditRestaurantReviewLoading(),
        const EditRestaurantReviewFailure(message: 'Server Error'),
      ],
    );
  });
}
