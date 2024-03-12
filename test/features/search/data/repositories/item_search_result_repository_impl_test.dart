import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/data/datasources/restaurant_result_remote_data_source.dart';
import 'package:rateeat_mobile/src/features/search_result/data/repositories/item_result_repository_impl.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/item_search_result.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/filter_item_result_params.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_state.dart';

import '../data/items.dart';
import 'item_search_result_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SearchResultRemoteDataSourceImpl>(),
])
void main() {
  late MockSearchResultRemoteDataSourceImpl
      mockSearchResultRemoteDataSourceImpl;
  late ItemResultRepository itemResultRepositoryImpl;

  setUp(() {
    mockSearchResultRemoteDataSourceImpl =
        MockSearchResultRemoteDataSourceImpl();
    itemResultRepositoryImpl = ItemResultRepositoryImpl(
      remoteDataSource: mockSearchResultRemoteDataSourceImpl,
    );
  });

  group("Item search result repository test", () {
    final itemsFilterParams = FilterItemResultsParams(
      searchQuery: "",
      selection: ItemsFilterState.closest,
      isFasting: false,
      location: const Location(latitude: 9.03, longitude: 38.8),
      category: 1,
      rating: 3,
      maximumPrice: 4000,
      page: 1,
      limit: 10,
    );
    test(
      "Should return closest items",
      () async {
        //arrange
        when(
          mockSearchResultRemoteDataSourceImpl.getClosestItems(
            filterResultParams: itemsFilterParams,
            page: 1,
            limit: 10,
            latitude: 9.03,
            longitude: 38.8,
          ),
        ).thenAnswer(
          (_) async => itemsSortedByDistance,
        );

        //act
        final result = await itemResultRepositoryImpl.getClosestItems(
          filterResultParams: itemsFilterParams,
          page: 1,
          limit: 10,
          latitude: 9.03,
          longitude: 38.8,
        );
        // assert
        expect(
          result,
          equals(
            Right(
              itemsSortedByDistance,
            ),
          ),
        );
      },
    );
    test(
      "Should return items sorted by price",
      () async {
        //arrange
        when(
          mockSearchResultRemoteDataSourceImpl.getPriceSortedItems(
            filterResultParams: itemsFilterParams,
            page: 1,
            limit: 10,
            latitude: 9.03,
            longitude: 38.8,
          ),
        ).thenAnswer(
          (_) async => itemsSortedByDistance,
        );

        //act
        final result = await itemResultRepositoryImpl.getPriceSortedItems(
          filterResultParams: itemsFilterParams,
          page: 1,
          limit: 10,
          latitude: 9.03,
          longitude: 38.8,
        );
        // assert
        expect(
          result,
          equals(
            Right(
              itemsSortedByDistance,
            ),
          ),
        );
      },
    );
    test(
      "Should return highest rated items",
      () async {
        //arrange
        when(
          mockSearchResultRemoteDataSourceImpl.getHighestRatedItems(
            filterResultParams: itemsFilterParams,
            page: 1,
            limit: 10,
            latitude: 9.03,
            longitude: 38.8,
          ),
        ).thenAnswer(
          (_) async => dummyItems,
        );

        //act
        final result = await itemResultRepositoryImpl.getHighestRatedItems(
          filterResultParams: itemsFilterParams,
          page: 1,
          limit: 10,
          latitude: 9.03,
          longitude: 38.8,
        );
        // assert
        expect(
          result,
          equals(
            Right(
              dummyItems,
            ),
          ),
        );
      },
    );
    test(
      "Should return most popular items",
      () async {
        //arrange
        when(
          mockSearchResultRemoteDataSourceImpl.getMostPopularItems(
            filterResultParams: itemsFilterParams,
            page: 1,
            limit: 10,
            latitude: 9.03,
            longitude: 38.8,
          ),
        ).thenAnswer(
          (_) async => dummyItems,
        );

        //act
        final result = await itemResultRepositoryImpl.getMostPopularItems(
          filterResultParams: itemsFilterParams,
          page: 1,
          limit: 10,
          latitude: 9.03,
          longitude: 38.8,
        );
        // assert
        expect(
          result,
          equals(
            Right(
              dummyItems,
            ),
          ),
        );
      },
    );
  });
}
