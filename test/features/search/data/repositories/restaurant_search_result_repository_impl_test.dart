import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/data/repositories/restaurant_result_repository_impl.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/restaurant_search_result.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';

import '../data/restaurants.dart';
import 'item_search_result_repository_impl_test.mocks.dart';

void main() {
  late MockSearchResultRemoteDataSourceImpl
      mockSearchResultRemoteDataSourceImpl;
  late RestaurantResultRepository itemResultRepositoryImpl;

  setUp(() {
    mockSearchResultRemoteDataSourceImpl =
        MockSearchResultRemoteDataSourceImpl();
    itemResultRepositoryImpl = RestaurantResultRepositoryImpl(
      remoteDataSource: mockSearchResultRemoteDataSourceImpl,
    );
  });

  group("Restaurant search result repository test", () {
    final restaurantsFilterParams = FilterRestaurantResultsParams(
      searchQuery: "",
      selection: RestaurantsFilterState.closest,
      isFasting: false,
      location: const Location(latitude: 9.03, longitude: 38.8),
      category: 1,
      rating: 3,
      maximumPrice: 4000,
      page: 1,
      limit: 10,
    );
    test(
      "Should return closest restaurants",
      () async {
        //arrange
        when(
          mockSearchResultRemoteDataSourceImpl.getClosestRestaurants(
            filterResultParams: restaurantsFilterParams,
            page: 1,
            limit: 10,
          ),
        ).thenAnswer(
          (_) async => dummyRestaurants,
        );

        //act
        final result = await itemResultRepositoryImpl.getClosestRestaurants(
          filterResultParams: restaurantsFilterParams,
          page: 1,
          limit: 10,
        );
        // assert
        expect(
          result,
          equals(
            Right(
              dummyRestaurants,
            ),
          ),
        );
      },
    );
    test(
      "Should return restaurants sorted by price",
      () async {
        //arrange
        when(
          mockSearchResultRemoteDataSourceImpl.getPriceSortedRestaurants(
            filterResultParams: restaurantsFilterParams,
            page: 1,
            limit: 10,
          ),
        ).thenAnswer(
          (_) async => dummyRestaurants,
        );

        //act
        final result = await itemResultRepositoryImpl.getPriceSortedRestaurants(
          filterResultParams: restaurantsFilterParams,
          page: 1,
          limit: 10,
        );
        // assert
        expect(
          result,
          equals(
            Right(
              dummyRestaurants,
            ),
          ),
        );
      },
    );
    test(
      "Should return highest rated restaurants",
      () async {
        //arrange
        when(
          mockSearchResultRemoteDataSourceImpl.getHighestRatedRestaurants(
            filterResultParams: restaurantsFilterParams,
            page: 1,
            limit: 10,
          ),
        ).thenAnswer(
          (_) async => dummyRestaurants,
        );

        //act
        final result =
            await itemResultRepositoryImpl.getHighestRatedRestaurants(
          filterResultParams: restaurantsFilterParams,
          page: 1,
          limit: 10,
        );
        // assert
        expect(
          result,
          equals(
            Right(
              dummyRestaurants,
            ),
          ),
        );
      },
    );
    test(
      "Should return most popular restaurants",
      () async {
        //arrange
        when(
          mockSearchResultRemoteDataSourceImpl.getMostPopularRestaurants(
            filterResultParams: restaurantsFilterParams,
            page: 1,
            limit: 10,
          ),
        ).thenAnswer(
          (_) async => dummyRestaurants,
        );

        //act
        final result = await itemResultRepositoryImpl.getMostPopularRestaurants(
          filterResultParams: restaurantsFilterParams,
          page: 1,
          limit: 10,
        );
        // assert
        expect(
          result,
          equals(
            Right(
              dummyRestaurants,
            ),
          ),
        );
      },
    );
  });
}
