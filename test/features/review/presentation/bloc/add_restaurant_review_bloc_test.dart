import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/add_restaurant_review_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/add_restaurant_review/add_restaurant_review_bloc.dart';

import 'add_restaurant_review_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AddRestaurantReviewUseCase>(),
])
void main() {
  late AddRestaurantReviewBloc addRestaurantReviewBloc;
  late MockAddRestaurantReviewUseCase mockAddRestaurantReviewUseCase;

  setUp(() {
    mockAddRestaurantReviewUseCase = MockAddRestaurantReviewUseCase();
    addRestaurantReviewBloc = AddRestaurantReviewBloc(
      addRestaurantReviewUseCase: mockAddRestaurantReviewUseCase,
    );
  });

  const testMessage = 'testMessage';
  final testAddRestaurantReviewRequestModel = AddRestaurantReviewRequestModel(
    restaurantId: 'testRestaurantId',
    rating: 5,
  );
  final params = AddRestaurantReviewUseCaseParams(
    addRestaurantReviewRequestModel: testAddRestaurantReviewRequestModel,
  );

  group('Add Restaurant Review Bloc', () {
    test('initial state should be AddRestaurantReviewInitial', () {
      // assert
      expect(addRestaurantReviewBloc.state, AddRestaurantReviewInitial());
    });
    blocTest<AddRestaurantReviewBloc, AddRestaurantReviewState>(
      'should emit [ AddRestaurantReviewLoading, AddRestaurantReviewSuccess] when AddRestaurantReviewRequestEvent is added.',
      build: () {
        when(
          mockAddRestaurantReviewUseCase(params),
        ).thenAnswer((_) async => const Right(testMessage));

        return addRestaurantReviewBloc;
      },
      act: (bloc) => bloc.add(
        AddRestaurantReviewRequestEvent(
          addRestaurantReviewRequest: testAddRestaurantReviewRequestModel,
        ),
      ),
      expect: () => <AddRestaurantReviewState>[
        AddRestaurantReviewLoading(),
        const AddRestaurantReviewSuccess(message: testMessage),
      ],
    );

    blocTest<AddRestaurantReviewBloc, AddRestaurantReviewState>(
      'should emit [ AddRestaurantReviewLoading, AddRestaurantReviewFailure] when AddRestaurantReviewRequestEvent is added.',
      build: () {
        when(
          mockAddRestaurantReviewUseCase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

        return addRestaurantReviewBloc;
      },
      act: (bloc) => bloc.add(
        AddRestaurantReviewRequestEvent(
          addRestaurantReviewRequest: testAddRestaurantReviewRequestModel,
        ),
      ),
      expect: () => <AddRestaurantReviewState>[
        AddRestaurantReviewLoading(),
        const AddRestaurantReviewFailure(message: 'Server Error'),
      ],
    );
  });
}
