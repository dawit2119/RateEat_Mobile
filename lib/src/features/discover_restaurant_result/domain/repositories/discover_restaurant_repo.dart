import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';

abstract class FetchRestaurantRepo {
  Future<Either<Failure, List<DiscoverRestaurantResultModel>>>
      getDiscoverRestaurantsResults({
    required double latitude,
    required double longitude,
    required double radius,
    required double maxPrice,
    required double minRating,
    required int limit,
    required List<String> tags,
    required String sorting,
    required bool fasting,
    required int page,
    required int maxTravelTime,
    required TransportMode transportMode,
  });
}
