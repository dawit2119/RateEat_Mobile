import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/price_item_update_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_event.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_state.dart';

import 'item_price_update_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PriceItemUsecase>(),
])
void main() {
  late PriceItemUpdateBloc priceItemUpdateBloc;
  late MockPriceItemUsecase mockPriceItemUsecase;

  setUp(() {
    mockPriceItemUsecase = MockPriceItemUsecase();
    priceItemUpdateBloc = PriceItemUpdateBloc(
      priceItemUsecase: mockPriceItemUsecase,
    );
  });

  const testMessage = 'testMessage';
  final testPriceItemReviewRequestModel = PriceItemReviewRequestModel(
    itemId: 'testItemId',
    price: 100,
  );
  final params = ItemPriceReviewUseCaseParams(
    priceItemReviewRequestModel: testPriceItemReviewRequestModel,
  );

  group('Item Price Update Bloc', () {
    test('initial state should be ItemPriceChangeInitial', () {
      // assert
      expect(priceItemUpdateBloc.state, ItemPriceChangeInitial());
    });
    blocTest<PriceItemUpdateBloc, ItemPriceChangeState>(
      'should emit [ ItemPriceChangeLoading, ItemPriceChangeSuccess] when ItemPriceChangeRequestEvent is added.',
      build: () {
        when(
          mockPriceItemUsecase(params),
        ).thenAnswer((_) async => const Right(testMessage));

        return priceItemUpdateBloc;
      },
      act: (bloc) => bloc.add(
        ItemPriceChangeRequestEvent(
          priceItemReviewRequestModel: testPriceItemReviewRequestModel,
        ),
      ),
      expect: () => <ItemPriceChangeState>[
        ItemPriceChangeLoading(),
        const ItemPriceChangeSuccess(message: testMessage),
      ],
    );

    blocTest<PriceItemUpdateBloc, ItemPriceChangeState>(
      'should emit [ ItemPriceChangeLoading, ItemPriceChangeError] when ItemPriceChangeRequestEvent is added.',
      build: () {
        when(
          mockPriceItemUsecase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

        return priceItemUpdateBloc;
      },
      act: (bloc) => bloc.add(
        ItemPriceChangeRequestEvent(
          priceItemReviewRequestModel: testPriceItemReviewRequestModel,
        ),
      ),
      expect: () => <ItemPriceChangeState>[
        ItemPriceChangeLoading(),
        const ItemPriceChangeError(error: 'Server Error'),
      ],
    );
  });
}
