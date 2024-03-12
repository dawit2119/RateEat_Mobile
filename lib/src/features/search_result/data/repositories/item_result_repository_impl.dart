import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/data/datasources/datasources.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/item_search_result.dart';

import '../../../../core/core.dart';
import '../../presentation/bloc/items_filter_search_result/filter_item_result_params.dart';

class ItemResultRepositoryImpl extends ItemResultRepository {
  final SearchResultRemoteDataSource remoteDataSource;

  ItemResultRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<ItemModel>>> getClosestItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final items = await remoteDataSource.getClosestItems(
        filterResultParams: filterResultParams,
        page: page,
        limit: limit,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(items);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, List<ItemModel>>> getHighestRatedItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final items = await remoteDataSource.getHighestRatedItems(
        filterResultParams: filterResultParams,
        page: page,
        limit: limit,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(items);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, List<ItemModel>>> getMostPopularItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final items = await remoteDataSource.getMostPopularItems(
        filterResultParams: filterResultParams,
        page: page,
        limit: limit,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(items);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, List<ItemModel>>> getPriceSortedItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final items = await remoteDataSource.getPriceSortedItems(
          filterResultParams: filterResultParams,
          page: page,
          limit: limit,
          latitude: latitude,
          longitude: longitude);
      return Right(items);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }
}
