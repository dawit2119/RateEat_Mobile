import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/entities/nearby_restaurants_response.dart';

import '../../../../core/core.dart';

abstract class NearbyRestaurantsRepo {
  Future<Either<Failure, NearbyRestaurantsResponse>> getNearbyRestaurants(
    double lat,
    double lng,
    List<String> tags,
    int page,
    int limit,
  );
}
