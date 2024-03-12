import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/live_search_data_provider.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/local_search_history_data_source.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/popular_search_item.dart';
import 'package:rateeat_mobile/src/features/live_search/data/repositories/live_search_repo_impl.dart';

import 'live_search_repo_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LiveSearchDataProvider>(),
  MockSpec<LocalSearchHistoryDataSource>(),
])
void main() {
  late LiveSearchRepoImpl liveSearchRepoImpl;
  late MockLiveSearchDataProvider mockLiveSearchDataProvider;
  late MockLocalSearchHistoryDataSource mockLocalSearchHistoryDataSource;

  setUp(() {
    mockLiveSearchDataProvider = MockLiveSearchDataProvider();
    mockLocalSearchHistoryDataSource = MockLocalSearchHistoryDataSource();
    liveSearchRepoImpl = LiveSearchRepoImpl(
      localSearchHistoryDataSource: mockLocalSearchHistoryDataSource,
      liveSearchDataProvider: mockLiveSearchDataProvider,
    );
  });

  const String id = "1";
  const String query = 'query';
  const double latitude = 1.0;
  const double longitude = 1.0;

  final testRestaurantModels = [
    const RestaurantModel(
      id: '1',
      name: 'restaurant',
    ),
  ];
  final testRestaurantResponse = [
    RestaurantResult(
      id: '1',
      name: 'restaurant',
    ),
  ];
  final testItemResponse = [
    ItemModel(
      itemId: '1',
      itemName: 'item',
      numberOfReviews: 0,
    ),
  ];

  final history = [
    History(
      id: "1",
      title: "title",
    )
  ];

  group('live search repo', () {
    group('search restaurants', () {
      test('should return a list of restaurants', () async {
        // arrange
        when(
          mockLiveSearchDataProvider.searchRestaurants(query),
        ).thenAnswer(
          (_) async => testRestaurantResponse,
        );

        // act
        final result = await liveSearchRepoImpl.searchRestaurants(query);
        // assert
        expect(result, equals(Right(testRestaurantResponse)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockLiveSearchDataProvider.searchRestaurants(query),
        ).thenThrow(ServerException(errorMessage: "Server Error"));

        // act
        final result = await liveSearchRepoImpl.searchRestaurants(query);
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: "Server Error"))));
      });
    });

    group('search items', () {
      test('should return a list of items', () async {
        // arrange
        when(
          mockLiveSearchDataProvider.searchItems(
            query,
            latitude: latitude,
            longitude: longitude,
          ),
        ).thenAnswer(
          (_) async => testItemResponse,
        );

        // act
        final result = await liveSearchRepoImpl.searchItems(
          query,
          latitude: latitude,
          longitude: longitude,
        );
        // assert
        expect(result, equals(Right(testItemResponse)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockLiveSearchDataProvider.searchItems(
            query,
            latitude: latitude,
            longitude: longitude,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));

        // act
        final result = await liveSearchRepoImpl.searchItems(
          query,
          latitude: latitude,
          longitude: longitude,
        );
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: "Server Error"))));
      });
    });

    group('add history', () {
      test('should add history', () async {
        // arrange
        when(
          mockLocalSearchHistoryDataSource.addHistory(
            history: history.first,
            localSearchType: LocalSearchType.items,
          ),
        ).thenAnswer(
          (_) async {},
        );

        // act
        final result = await liveSearchRepoImpl.addHistory(
          history: history.first,
          localSearchType: LocalSearchType.items,
        );
        // assert
        expect(result, equals(const Right(null)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockLocalSearchHistoryDataSource.addHistory(
            history: history.first,
            localSearchType: LocalSearchType.items,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));

        // act
        final result = await liveSearchRepoImpl.addHistory(
          history: history.first,
          localSearchType: LocalSearchType.items,
        );
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: "Server Error"))));
      });
    });

    group('clear history', () {
      test('should clear history', () async {
        // arrange
        when(
          mockLocalSearchHistoryDataSource.clearHistory(
            localSearchType: LocalSearchType.items,
          ),
        ).thenAnswer(
          (_) async {},
        );

        // act
        final result = await liveSearchRepoImpl.clearHistory(
          localSearchType: LocalSearchType.items,
        );
        // assert
        expect(result, equals(const Right(null)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockLocalSearchHistoryDataSource.clearHistory(
            localSearchType: LocalSearchType.items,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));

        // act
        final result = await liveSearchRepoImpl.clearHistory(
          localSearchType: LocalSearchType.items,
        );
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: "Server Error"))));
      });
    });

    group('delete history', () {
      test('should delete history', () async {
        // arrange
        when(
          mockLocalSearchHistoryDataSource.deleteHistory(
            id: id,
            localSearchType: LocalSearchType.items,
          ),
        ).thenAnswer(
          (_) async {},
        );

        // act
        final result = await liveSearchRepoImpl.deleteHistory(
          id: id,
          localSearchType: LocalSearchType.items,
        );
        // assert
        expect(result, equals(const Right(null)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockLocalSearchHistoryDataSource.deleteHistory(
            id: id,
            localSearchType: LocalSearchType.items,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));

        // act
        final result = await liveSearchRepoImpl.deleteHistory(
          id: id,
          localSearchType: LocalSearchType.items,
        );
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: "Server Error"))));
      });
    });

    group('get history list', () {
      test('should return a list of history', () async {
        // arrange
        when(
          mockLocalSearchHistoryDataSource.getHistoryList(
            localSearchType: LocalSearchType.items,
          ),
        ).thenAnswer(
          (_) async => history,
        );

        // act
        final result = await liveSearchRepoImpl.getHistoryList(
          localSearchType: LocalSearchType.items,
        );
        // assert
        expect(result, equals(Right(history)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockLocalSearchHistoryDataSource.getHistoryList(
            localSearchType: LocalSearchType.items,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));

        // act
        final result = await liveSearchRepoImpl.getHistoryList(
          localSearchType: LocalSearchType.items,
        );
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: "Server Error"))));
      });
    });

    group('get popular search items', () {
      test('should return a list of popular search items', () async {
        // arrange
        when(
          mockLiveSearchDataProvider.getPopularRestaurants(
            limit: 10,
            page: 1,
          ),
        ).thenAnswer(
          (_) async => testRestaurantModels,
        );
        when(
          mockLiveSearchDataProvider.getPopularItems(
            limit: 10,
            page: 1,
          ),
        ).thenAnswer(
          (_) async => testItemResponse,
        );

        // act
        final result = await liveSearchRepoImpl.getPopularSearchItems(
          limit: 10,
          page: 1,
        );
        // assert
        expect(
          result,
          equals(
            const Right(
              PopularSearchModel(
                restaurants: ["restaurant"],
                items: ["item"],
              ),
            ),
          ),
        );
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockLiveSearchDataProvider.getPopularRestaurants(
            limit: 10,
            page: 1,
          ),
        ).thenThrow(ServerException(errorMessage: "Server Error"));

        // act
        final result = await liveSearchRepoImpl.getPopularSearchItems(
          limit: 10,
          page: 1,
        );
        // assert
        expect(
          result,
          equals(
            Left(
              ServerFailure(errorMessage: "Server Error"),
            ),
          ),
        );
      });
    });
  });
}
