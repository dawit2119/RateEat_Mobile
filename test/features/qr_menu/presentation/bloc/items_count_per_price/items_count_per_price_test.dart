import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'items_count_per_price_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetNumberOfItemsPerPriceRangeUsecase>()])
void main() {
  late ItemsCountPerPriceBloc itemsCountPerPriceBloc;
  late MockGetNumberOfItemsPerPriceRangeUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockGetNumberOfItemsPerPriceRangeUsecase();
    itemsCountPerPriceBloc = ItemsCountPerPriceBloc(
        getNumberOfItemsPerPriceRangeUsecase: mockUsecase);
  });

  test('initial state should be ItemsCountPerPriceInitial', () {
    expect(itemsCountPerPriceBloc.state, ItemsCountPerPriceInitial());
  });

  blocTest<ItemsCountPerPriceBloc, ItemsCountPerPriceState>(
    'emits [ItemsCountPerPriceLoading, ItemsCountPerPriceLoaded] when data is successfully fetched',
    build: () {
      when(mockUsecase.call(any)).thenAnswer((_) async => Right([
            PriceRangeModel(minPrice: 0, maxPrice: 100, count: 5),
            PriceRangeModel(minPrice: 100, maxPrice: 200, count: 10),
          ]));
      return itemsCountPerPriceBloc;
    },
    act: (bloc) => bloc.add(GetItemsCountPerPriceRange(
      restaurantId: 'restaurant_id',
      isFasting: false,
      category: null,
      minRating: null,
      query: '',
    )),
    expect: () => [
      ItemsCountPerPriceLoading(),
      ItemsCountPerPriceLoaded(priceRanges: [
        PriceRangeModel(minPrice: 0, maxPrice: 100, count: 5),
        PriceRangeModel(minPrice: 100, maxPrice: 200, count: 10),
      ])
    ],
  );

  blocTest<ItemsCountPerPriceBloc, ItemsCountPerPriceState>(
    'emits [ItemsCountPerPriceLoading, ItemsCountPerPriceFailed] when there is an error',
    build: () {
      when(mockUsecase.call(any))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: "error")));
      return itemsCountPerPriceBloc;
    },
    act: (bloc) => bloc.add(GetItemsCountPerPriceRange(
      restaurantId: 'restaurant_id',
      isFasting: false,
      category: null,
      minRating: null,
      query: '',
    )),
    expect: () => [
      ItemsCountPerPriceLoading(),
      ItemsCountPerPriceFailed(message: "ServerFailure()"),
    ],
  );

  tearDown(() {
    itemsCountPerPriceBloc.close();
  });
}
