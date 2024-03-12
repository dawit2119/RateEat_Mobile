import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/domain/entities/restaurant_search_result.dart';

import '../../../../core/core.dart';
import '../../domain/repositories/get_restaurant_repository.dart';
import '../datasources/get_restaurant_dp.dart';
import '../models/search_restaurant_model.dart';

class GetRestaurantRepoImpl extends GetRestaurantRepository {
  final GetRestaurantDataProvider getRestaurantDataProvider;

  GetRestaurantRepoImpl({required this.getRestaurantDataProvider});
  @override
  Future<Either<Failure, List<RestaurantSearchResultModel>>> searchRestaurant(
      {required String query}) async {
    try {
      final restaurantSearchResult =
          await getRestaurantDataProvider.searchRestaurant(query: query);
      return Right(restaurantSearchResult);
    } catch (exception) {
      return Left(
        mapExceptionToFailure(exception: exception),
      );
    }
  }

  @override
  Future<Either<Failure, List<RestaurantSearchResult>>> getNearbyRestaurants(
      {required double latitude, required double longitude}) async {
    try {
      final restaurantSearchResult =
          await getRestaurantDataProvider.getNearbyRestaurants(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(restaurantSearchResult);
    } catch (exception) {
      return Left(
        mapExceptionToFailure(exception: exception),
      );
    }
  }
}
