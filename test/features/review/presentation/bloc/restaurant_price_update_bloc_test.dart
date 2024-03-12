import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/price_update_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_event.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_state.dart';

import 'restaurant_price_update_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PriceReviewUsecase>(),
])
void main() {
  late PriceUpdateBloc priceUpdateBloc;
  late MockPriceReviewUsecase mockPriceReviewUsecase;

  setUp(() {
    mockPriceReviewUsecase = MockPriceReviewUsecase();
    priceUpdateBloc = PriceUpdateBloc(
      priceReviewUsecase: mockPriceReviewUsecase,
    );
  });

  const testMessage = 'testMessage';
  final testPriceReviewRequestModel = PriceReviewRequestModel(
    restaurantId: 'testRestaurantId',
    images: [],
  );
  final params = PriceReviewUseCaseParams(
    priceReviewRequestModel: testPriceReviewRequestModel,
  );

  group('Restaurant Price Update Bloc', () {
    test('initial state should be PriceChangeInitial', () {
      // assert
      expect(priceUpdateBloc.state, PriceChangeInitial());
    });
    blocTest<PriceUpdateBloc, PriceChangeState>(
      'should emit [ PriceChangeLoading, PriceChangeSuccess] when PriceChangeRequestEvent is added.',
      build: () {
        when(
          mockPriceReviewUsecase(params),
        ).thenAnswer((_) async => const Right(testMessage));

        return priceUpdateBloc;
      },
      act: (bloc) => bloc.add(PriceChangeRequestEvent(
        priceReviewRequestModel: testPriceReviewRequestModel,
      )),
      expect: () => <PriceChangeState>[
        PriceChangeLoading(),
        const PriceChangeSuccess(message: testMessage),
      ],
    );

    blocTest<PriceUpdateBloc, PriceChangeState>(
      'should emit [ PriceChangeLoading, PriceChangeError] when PriceChangeRequestEvent is added.',
      build: () {
        when(
          mockPriceReviewUsecase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: "Server Error")));

        return priceUpdateBloc;
      },
      act: (bloc) => bloc.add(PriceChangeRequestEvent(
        priceReviewRequestModel: testPriceReviewRequestModel,
      )),
      expect: () => <PriceChangeState>[
        PriceChangeLoading(),
        const PriceChangeError(error: "Server Error"),
      ],
    );
  });
}
