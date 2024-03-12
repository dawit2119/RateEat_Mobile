import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_closest_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_highest_rated_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_most_popular_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_price_sorted_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';

import '../../data/data/restaurants.dart';
import 'restaurants_filter_results_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetHighestRatedRestaurantsUseCase>(),
  MockSpec<GetMostPopularRestaurantsUseCase>(),
  MockSpec<GetPriceSortedRestaurantsUseCase>(),
  MockSpec<GetClosestRestaurantsUseCase>(),
])
void main() {
  late MockGetHighestRatedRestaurantsUseCase mockGetHighestRatedItemsUseCase;
  late MockGetMostPopularRestaurantsUseCase
      mockGetMostPopularRestaurantsUseCase;
  late MockGetPriceSortedRestaurantsUseCase
      mockGetPriceSortedRestaurantsUseCase;
  late MockGetClosestRestaurantsUseCase mockGetClosestRestaurantsUseCase;
  late RestaurantsFilterSearchResultsBloc restaurantsFilterSearchResultsBloc;

  setUp(() {
    mockGetHighestRatedItemsUseCase = MockGetHighestRatedRestaurantsUseCase();
    mockGetMostPopularRestaurantsUseCase =
        MockGetMostPopularRestaurantsUseCase();
    mockGetPriceSortedRestaurantsUseCase =
        MockGetPriceSortedRestaurantsUseCase();
    mockGetClosestRestaurantsUseCase = MockGetClosestRestaurantsUseCase();
    restaurantsFilterSearchResultsBloc = RestaurantsFilterSearchResultsBloc(
      getClosestRestaurantsUseCase: mockGetClosestRestaurantsUseCase,
      getHighestRatedRestaurantsUseCase: mockGetHighestRatedItemsUseCase,
      getMostPopularRestaurantsUseCase: mockGetMostPopularRestaurantsUseCase,
      getPriceSortedRestaurantsUseCase: mockGetPriceSortedRestaurantsUseCase,
    );
  });
  group(
    "Restaurants Search unit test",
    () {
      final restaurantsFilterParams = FilterRestaurantResultsParams(
        searchQuery: "",
        selection: RestaurantsFilterState.closest,
        isFasting: false,
        location: const Location(latitude: 9.03, longitude: 38.8),
        category: 0,
        rating: 3,
        maximumPrice: 4000,
        page: 1,
        limit: 10,
      );
      test(
        "Initial state must be FilterItemsLoading",
        () {
          expect(
            restaurantsFilterSearchResultsBloc.state,
            const FilterRestaurantsLoading(
              selection: RestaurantsFilterState.highestRated,
              isFasting: false,
              searchQuery: '',
              location: null,
              category: 0,
              rating: 1,
              maximumPrice: 2000,
            ),
          );
        },
      );
      blocTest<RestaurantsFilterSearchResultsBloc,
              RestaurantsFilterSearchResultsState>(
          "Should return highest rated restaurants fetched state",
          build: () {
            when(
              mockGetHighestRatedItemsUseCase(
                any,
              ),
            ).thenAnswer(
              (_) async => Right(
                dummyRestaurants,
              ),
            );

            return restaurantsFilterSearchResultsBloc;
          },
          act: (bloc) => bloc.add(
                GetFilteredRestaurantEvent(
                    location: restaurantsFilterParams.location,
                    category: restaurantsFilterParams.category,
                    isFasting: restaurantsFilterParams.isFasting,
                    searchQuery: restaurantsFilterParams.searchQuery,
                    selection: RestaurantsFilterState.highestRated,
                    rating: restaurantsFilterParams.rating,
                    maximumPrice: restaurantsFilterParams.maximumPrice),
              ),
          expect: () => <RestaurantsFilterSearchResultsState>[
                const FilterRestaurantsLoading(
                  selection: RestaurantsFilterState.highestRated,
                  isFasting: false,
                  searchQuery: '',
                  location: null,
                  category: 0,
                  rating: 1,
                  maximumPrice: 2000,
                ),
                FilterRestaurantsSuccess(
                  status: true,
                  searchFilteredRestaurants: dummyRestaurants,
                  selection: RestaurantsFilterState.highestRated,
                  searchQuery: "",
                  isFasting: restaurantsFilterParams.isFasting,
                  location: restaurantsFilterParams.location,
                  category: restaurantsFilterParams.category,
                  rating: restaurantsFilterParams.rating,
                  maximumPrice: restaurantsFilterParams.maximumPrice,
                )
              ]);
      blocTest<RestaurantsFilterSearchResultsBloc,
              RestaurantsFilterSearchResultsState>(
          "Should return most popular restaurants fetched state",
          build: () {
            when(
              mockGetMostPopularRestaurantsUseCase(
                any,
              ),
            ).thenAnswer(
              (_) async => Right(
                dummyRestaurants,
              ),
            );

            return restaurantsFilterSearchResultsBloc;
          },
          act: (bloc) => bloc.add(
                GetFilteredRestaurantEvent(
                    location: restaurantsFilterParams.location,
                    category: restaurantsFilterParams.category,
                    isFasting: restaurantsFilterParams.isFasting,
                    searchQuery: restaurantsFilterParams.searchQuery,
                    selection: RestaurantsFilterState.mostPopular,
                    rating: restaurantsFilterParams.rating,
                    maximumPrice: restaurantsFilterParams.maximumPrice),
              ),
          expect: () => <RestaurantsFilterSearchResultsState>[
                const FilterRestaurantsLoading(
                  selection: RestaurantsFilterState.mostPopular,
                  isFasting: false,
                  searchQuery: '',
                  location: null,
                  category: 0,
                  rating: 1,
                  maximumPrice: 2000,
                ),
                FilterRestaurantsSuccess(
                  status: true,
                  searchFilteredRestaurants: dummyRestaurants,
                  selection: RestaurantsFilterState.mostPopular,
                  searchQuery: "",
                  isFasting: restaurantsFilterParams.isFasting,
                  location: restaurantsFilterParams.location,
                  category: restaurantsFilterParams.category,
                  rating: restaurantsFilterParams.rating,
                  maximumPrice: restaurantsFilterParams.maximumPrice,
                )
              ]);
      blocTest<RestaurantsFilterSearchResultsBloc,
              RestaurantsFilterSearchResultsState>(
          "Should return highest closest restaurants",
          build: () {
            when(
              mockGetClosestRestaurantsUseCase(
                any,
              ),
            ).thenAnswer(
              (_) async => Right(
                dummyRestaurants,
              ),
            );

            return restaurantsFilterSearchResultsBloc;
          },
          act: (bloc) => bloc.add(
                GetFilteredRestaurantEvent(
                    location: restaurantsFilterParams.location,
                    category: restaurantsFilterParams.category,
                    isFasting: restaurantsFilterParams.isFasting,
                    searchQuery: restaurantsFilterParams.searchQuery,
                    selection: RestaurantsFilterState.closest,
                    rating: restaurantsFilterParams.rating,
                    maximumPrice: restaurantsFilterParams.maximumPrice),
              ),
          expect: () => <RestaurantsFilterSearchResultsState>[
                const FilterRestaurantsLoading(
                  selection: RestaurantsFilterState.closest,
                  isFasting: false,
                  searchQuery: '',
                  location: null,
                  category: 0,
                  rating: 1,
                  maximumPrice: 2000,
                ),
                FilterRestaurantsSuccess(
                  status: true,
                  searchFilteredRestaurants: dummyRestaurants,
                  selection: RestaurantsFilterState.closest,
                  searchQuery: "",
                  isFasting: restaurantsFilterParams.isFasting,
                  location: restaurantsFilterParams.location,
                  category: restaurantsFilterParams.category,
                  rating: restaurantsFilterParams.rating,
                  maximumPrice: restaurantsFilterParams.maximumPrice,
                )
              ]);
      blocTest<RestaurantsFilterSearchResultsBloc,
          RestaurantsFilterSearchResultsState>(
        "Should return price sorted restaurants",
        build: () {
          when(
            mockGetPriceSortedRestaurantsUseCase(
              any,
            ),
          ).thenAnswer(
            (_) async => Right(
              dummyRestaurants,
            ),
          );

          return restaurantsFilterSearchResultsBloc;
        },
        act: (bloc) => bloc.add(
          GetFilteredRestaurantEvent(
              location: restaurantsFilterParams.location,
              category: restaurantsFilterParams.category,
              isFasting: restaurantsFilterParams.isFasting,
              searchQuery: restaurantsFilterParams.searchQuery,
              selection: RestaurantsFilterState.priceSorted,
              rating: restaurantsFilterParams.rating,
              maximumPrice: restaurantsFilterParams.maximumPrice),
        ),
        expect: () => <RestaurantsFilterSearchResultsState>[
          const FilterRestaurantsLoading(
            selection: RestaurantsFilterState.priceSorted,
            isFasting: false,
            searchQuery: '',
            location: null,
            category: 0,
            rating: 1,
            maximumPrice: 2000,
          ),
          FilterRestaurantsSuccess(
            status: true,
            searchFilteredRestaurants: dummyRestaurants,
            selection: RestaurantsFilterState.priceSorted,
            searchQuery: "",
            isFasting: restaurantsFilterParams.isFasting,
            location: restaurantsFilterParams.location,
            category: restaurantsFilterParams.category,
            rating: restaurantsFilterParams.rating,
            maximumPrice: restaurantsFilterParams.maximumPrice,
          )
        ],
      );
    },
  );
}
