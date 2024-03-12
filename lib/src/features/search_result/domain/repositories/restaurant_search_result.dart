import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';

abstract class RestaurantResultRepository {
  Future<Either<Failure, List<RestaurantModel>>> getMostPopularRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit});
  Future<Either<Failure, List<RestaurantModel>>> getClosestRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit});
  Future<Either<Failure, List<RestaurantModel>>> getHighestRatedRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit});
  Future<Either<Failure, List<RestaurantModel>>> getPriceSortedRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit});
}
