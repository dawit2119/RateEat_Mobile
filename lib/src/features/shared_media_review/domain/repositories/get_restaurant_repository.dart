import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../entities/restaurant_search_result.dart';

abstract class GetRestaurantRepository {
  Future<Either<Failure, List<RestaurantSearchResult>>> searchRestaurant(
      {required String query});
  Future<Either<Failure, List<RestaurantSearchResult>>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
  });
}
