import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/search_result/data/datasources/restaurant_result_remote_data_source.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../../domain/repositories/restaurant_search_result.dart';

class RestaurantResultRepositoryImpl extends RestaurantResultRepository {
  // final RestaurantResultLocalDatasource localDatasource;
  final SearchResultRemoteDataSource remoteDataSource;

  RestaurantResultRepositoryImpl({
    // required this.localDatasource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<RestaurantModel>>> getClosestRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit}) async {
    try {
      final restaurants = await remoteDataSource.getClosestRestaurants(
          filterResultParams: filterResultParams, page: page, limit: limit);
      return Right(restaurants);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantModel>>> getHighestRatedRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit}) async {
    try {
      final restaurants = await remoteDataSource.getHighestRatedRestaurants(
          filterResultParams: filterResultParams, page: page, limit: limit);
      return Right(restaurants);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantModel>>> getMostPopularRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit}) async {
    try {
      final restaurants = await remoteDataSource.getMostPopularRestaurants(
          filterResultParams: filterResultParams, page: page, limit: limit);
      return Right(restaurants);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantModel>>> getPriceSortedRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit}) async {
    try {
      final restaurants = await remoteDataSource.getPriceSortedRestaurants(
          filterResultParams: filterResultParams, page: page, limit: limit);
      return Right(restaurants);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }
}
