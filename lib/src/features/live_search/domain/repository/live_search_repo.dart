import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/entities/popular_search_items.dart';

import '../../../../core/core.dart';
import '../../../discover_item/data/models/search_result.dart';
import '../../../homepage/domain/entities/item.dart';
import '../../data/data_sources/local_search_history_data_source.dart';

abstract class LiveSearchRepository {
  Future<Either<Failure, PopularSearchItems>> getPopularSearchItems(
      {required int limit, required int page});
  Future<Either<Failure, List<RestaurantResult>>> searchRestaurants(
    String query,
  );
  Future<Either<Failure, List<Item>>> searchItems(
    String query, {
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, void>> addHistory({
    required History history,
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  });
  Future<Either<Failure, List<History>>> getHistoryList({
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  });
  Future<Either<Failure, void>> clearHistory({
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  });
  Future<Either<Failure, void>> deleteHistory({
    required String id,
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  });
}
