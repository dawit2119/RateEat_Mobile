import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/homepage/data/data.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/popular_search_item.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/repository/live_search_repo.dart';

import '../../../../core/core.dart';
import '../../../discover_item/data/models/search_result.dart';
import '../data_sources/live_search_data_provider.dart';
import '../data_sources/local_search_history_data_source.dart';

class LiveSearchRepoImpl implements LiveSearchRepository {
  final LiveSearchDataProvider liveSearchDataProvider;
  final LocalSearchHistoryDataSource localSearchHistoryDataSource;
  LiveSearchRepoImpl({
    required this.localSearchHistoryDataSource,
    required this.liveSearchDataProvider,
  });

  @override
  Future<Either<Failure, List<RestaurantResult>>> searchRestaurants(
      String query) async {
    try {
      return Right(
        await liveSearchDataProvider.searchRestaurants(query),
      );
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ItemModel>>> searchItems(
    String query, {
    required double latitude,
    required double longitude,
  }) async {
    try {
      return Right(
        await liveSearchDataProvider.searchItems(
          query,
          latitude: latitude,
          longitude: longitude,
        ),
      );
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addHistory(
      {required History history,
      LocalSearchType localSearchType = LocalSearchType.restaurants}) async {
    try {
      return Right(
        await localSearchHistoryDataSource.addHistory(
            history: history, localSearchType: localSearchType),
      );
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory(
      {LocalSearchType localSearchType = LocalSearchType.restaurants}) async {
    try {
      return Right(
        await localSearchHistoryDataSource.clearHistory(
          localSearchType: localSearchType,
        ),
      );
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteHistory(
      {required String id,
      LocalSearchType localSearchType = LocalSearchType.restaurants}) async {
    try {
      return Right(
        await localSearchHistoryDataSource.deleteHistory(
          id: id,
          localSearchType: localSearchType,
        ),
      );
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<History>>> getHistoryList(
      {LocalSearchType localSearchType = LocalSearchType.restaurants}) async {
    try {
      return Right(
        await localSearchHistoryDataSource.getHistoryList(
          localSearchType: localSearchType,
        ),
      );
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PopularSearchModel>> getPopularSearchItems(
      {required int limit, required int page}) async {
    try {
      final restaurants = await liveSearchDataProvider.getPopularRestaurants(
        limit: limit,
        page: page,
      );
      final items = await liveSearchDataProvider.getPopularItems(
          limit: limit, page: page);
      var restaurantsSearches = restaurants
          .map(
            (restaurant) => restaurant.name ?? "",
          )
          .toList();
      var itemSearches = items.map((item) => item.itemName).toList();
      return Right(
        PopularSearchModel(
          items: itemSearches,
          restaurants: restaurantsSearches,
        ),
      );
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
