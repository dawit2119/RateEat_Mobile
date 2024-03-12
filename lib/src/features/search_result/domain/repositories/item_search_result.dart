import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import '../../../../core/core.dart';
import '../../presentation/bloc/items_filter_search_result/filter_item_result_params.dart';

abstract class ItemResultRepository {
  Future<Either<Failure, List<ItemModel>>> getMostPopularItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, List<ItemModel>>> getClosestItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, List<ItemModel>>> getHighestRatedItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, List<ItemModel>>> getPriceSortedItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  });
}
