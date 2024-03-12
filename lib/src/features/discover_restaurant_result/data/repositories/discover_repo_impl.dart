import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../domain/repositories/discover_restaurant_repo.dart';
import '../datasources/discover_restaurant_dp.dart';
import '../models/discover_restaurant_result_model/discover_restaurant_result_model.dart';

class FetchRestaurantRepoImpl implements FetchRestaurantRepo {
  final DiscoverRestaurantDataProvider discoverRestaurantResultDataProvider;

  FetchRestaurantRepoImpl({required this.discoverRestaurantResultDataProvider});

  @override
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
  }) async {
    try {
      var discoverRestaurantResult = await discoverRestaurantResultDataProvider
          .getDiscoverRestaurantResults(
        latitude: latitude,
        longitude: longitude,
        maxPrice: maxPrice,
        minRating: minRating,
        radius: radius,
        limit: limit,
        tags: tags,
        sorting: sorting,
        fasting: fasting,
        page: page,
        maxTravelTime: maxTravelTime,
        transportMode: transportMode,
      );
      return Right(discoverRestaurantResult);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    }
  }
}
