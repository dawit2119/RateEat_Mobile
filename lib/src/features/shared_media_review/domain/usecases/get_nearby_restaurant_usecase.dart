import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../entities/restaurant_search_result.dart';
import '../repositories/get_restaurant_repository.dart';

class GetNearbyRestaurantUsecase
    extends UseCase<List<RestaurantSearchResult>, NearbyRestaurantParams> {
  final GetRestaurantRepository getRestaurantRepository;

  GetNearbyRestaurantUsecase({required this.getRestaurantRepository});

  @override
  Future<Either<Failure, List<RestaurantSearchResult>>> call(
      NearbyRestaurantParams params) async {
    return getRestaurantRepository.getNearbyRestaurants(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class NearbyRestaurantParams {
  final double latitude;
  final double longitude;

  NearbyRestaurantParams({required this.latitude, required this.longitude});
}
