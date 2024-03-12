import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_closest_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_highest_rated_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_most_popular_items_use_case.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_price_sorted_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/filter_item_result_params.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_state.dart';

import '../../data/data/items.dart';
import 'Items_filter_results_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetHighestRatedItemsUseCase>(),
  MockSpec<GetMostPopularItemsUseCase>(),
  MockSpec<GetPriceSortedItemsUseCase>(),
  MockSpec<GetClosestItemsUseCase>(),
])
void main() {
  late MockGetHighestRatedItemsUseCase mockGetHighestRatedItemsUseCase;
  late MockGetMostPopularItemsUseCase mockGetMostPopularItemsUseCase;
  late MockGetPriceSortedItemsUseCase mockGetPriceSortedItemsUseCase;
  late MockGetClosestItemsUseCase mockGetClosestItemsUseCase;
  late ItemsFilterSearchResultsBloc itemsFilterSearchResultsBloc;

  setUp(() {
    mockGetHighestRatedItemsUseCase = MockGetHighestRatedItemsUseCase();
    mockGetMostPopularItemsUseCase = MockGetMostPopularItemsUseCase();
    mockGetPriceSortedItemsUseCase = MockGetPriceSortedItemsUseCase();
    mockGetClosestItemsUseCase = MockGetClosestItemsUseCase();
    itemsFilterSearchResultsBloc = ItemsFilterSearchResultsBloc(
      getClosestItemsUseCase: mockGetClosestItemsUseCase,
      getHighestRatedItemsUseCase: mockGetHighestRatedItemsUseCase,
      getMostPopularItemsUseCase: mockGetMostPopularItemsUseCase,
      getPriceSortedItemsUseCase: mockGetPriceSortedItemsUseCase,
    );
  });
  group("Items Search unit test", () {
    final itemsFilterParams = FilterItemResultsParams(
      searchQuery: "",
      selection: ItemsFilterState.highestRated,
      isFasting: false,
      location: const Location(latitude: 9.03, longitude: 38.8),
      category: 1,
      rating: 3,
      maximumPrice: 4000,
      page: 1,
      limit: 10,
    );
    test(
      "Initial state must be FilterItemsLoading",
      () {
        expect(
          itemsFilterSearchResultsBloc.state,
          const FilterItemsLoading(
            selection: ItemsFilterState.closest,
            searchQuery: "",
            isFasting: false,
            category: 1,
            maximumPrice: 5000,
            rating: 3,
          ),
        );
      },
    );
    blocTest<ItemsFilterSearchResultsBloc, ItemsFilterSearchResultsState>(
        "Should return highest rated item state",
        build: () {
          when(
            mockGetHighestRatedItemsUseCase(
              any,
            ),
          ).thenAnswer(
            (_) async => Right(
              dummyItems,
            ),
          );

          return itemsFilterSearchResultsBloc;
        },
        act: (bloc) => bloc.add(
              GetFilteredItemsEvent(
                  location: itemsFilterParams.location,
                  isFasting: itemsFilterParams.isFasting,
                  searchQuery: itemsFilterParams.searchQuery,
                  selection: itemsFilterParams.selection,
                  rating: itemsFilterParams.rating,
                  maximumPrice: itemsFilterParams.maximumPrice),
            ),
        expect: () => <ItemsFilterSearchResultsState>[
              const FilterItemsLoading(
                selection: ItemsFilterState.highestRated,
                searchQuery: "",
                isFasting: false,
                category: 1,
                maximumPrice: 5000,
                rating: 3,
              ),
              FilterItemsSuccess(
                status: true,
                searchFilteredItems: dummyItems,
                selection: ItemsFilterState.highestRated,
                searchQuery: "",
                isFasting: false,
                category: 1,
                maximumPrice: 4000,
                rating: 3,
                location: const Location(
                  latitude: 9.03,
                  longitude: 38.8,
                ),
              )
            ]);
    blocTest<ItemsFilterSearchResultsBloc, ItemsFilterSearchResultsState>(
        "Should return price sorted items state",
        build: () {
          when(
            mockGetPriceSortedItemsUseCase(
              any,
            ),
          ).thenAnswer(
            (_) async => Right(
              dummyItems,
            ),
          );

          return itemsFilterSearchResultsBloc;
        },
        act: (bloc) => bloc.add(
              GetFilteredItemsEvent(
                  location: itemsFilterParams.location,
                  isFasting: itemsFilterParams.isFasting,
                  searchQuery: itemsFilterParams.searchQuery,
                  selection: ItemsFilterState.priceSorted,
                  rating: itemsFilterParams.rating,
                  maximumPrice: itemsFilterParams.maximumPrice),
            ),
        expect: () => <ItemsFilterSearchResultsState>[
              const FilterItemsLoading(
                selection: ItemsFilterState.priceSorted,
                searchQuery: "",
                isFasting: false,
                category: 1,
                maximumPrice: 5000,
                rating: 3,
              ),
              FilterItemsSuccess(
                status: true,
                searchFilteredItems: dummyItems,
                selection: ItemsFilterState.priceSorted,
                searchQuery: "",
                isFasting: false,
                category: 1,
                maximumPrice: 4000,
                rating: 3,
                location: const Location(
                  latitude: 9.03,
                  longitude: 38.8,
                ),
              )
            ]);
    blocTest<ItemsFilterSearchResultsBloc, ItemsFilterSearchResultsState>(
        "Should return most popular item state",
        build: () {
          when(
            mockGetMostPopularItemsUseCase(
              any,
            ),
          ).thenAnswer(
            (_) async => Right(
              dummyItems,
            ),
          );

          return itemsFilterSearchResultsBloc;
        },
        act: (bloc) => bloc.add(
              GetFilteredItemsEvent(
                  location: itemsFilterParams.location,
                  isFasting: itemsFilterParams.isFasting,
                  searchQuery: itemsFilterParams.searchQuery,
                  selection: ItemsFilterState.mostPopular,
                  rating: itemsFilterParams.rating,
                  maximumPrice: itemsFilterParams.maximumPrice),
            ),
        expect: () => <ItemsFilterSearchResultsState>[
              const FilterItemsLoading(
                selection: ItemsFilterState.mostPopular,
                searchQuery: "",
                isFasting: false,
                category: 1,
                maximumPrice: 5000,
                rating: 3,
              ),
              FilterItemsSuccess(
                status: true,
                searchFilteredItems: dummyItems,
                selection: ItemsFilterState.mostPopular,
                searchQuery: "",
                isFasting: false,
                category: 1,
                maximumPrice: 4000,
                rating: 3,
                location: const Location(
                  latitude: 9.03,
                  longitude: 38.8,
                ),
              )
            ]);
    blocTest<ItemsFilterSearchResultsBloc, ItemsFilterSearchResultsState>(
        "Should return closest item state",
        build: () {
          when(
            mockGetClosestItemsUseCase(
              any,
            ),
          ).thenAnswer(
            (_) async => Right(
              dummyItems,
            ),
          );

          return itemsFilterSearchResultsBloc;
        },
        act: (bloc) => bloc.add(
              GetFilteredItemsEvent(
                  location: itemsFilterParams.location,
                  isFasting: itemsFilterParams.isFasting,
                  searchQuery: itemsFilterParams.searchQuery,
                  selection: ItemsFilterState.closest,
                  rating: itemsFilterParams.rating,
                  maximumPrice: itemsFilterParams.maximumPrice),
            ),
        expect: () => <ItemsFilterSearchResultsState>[
              const FilterItemsLoading(
                selection: ItemsFilterState.closest,
                searchQuery: "",
                isFasting: false,
                category: 1,
                maximumPrice: 5000,
                rating: 3,
              ),
              FilterItemsSuccess(
                status: true,
                searchFilteredItems: dummyItems,
                selection: ItemsFilterState.closest,
                searchQuery: "",
                isFasting: false,
                category: 1,
                maximumPrice: 4000,
                rating: 3,
                location: const Location(
                  latitude: 9.03,
                  longitude: 38.8,
                ),
              )
            ]);
  });
}
