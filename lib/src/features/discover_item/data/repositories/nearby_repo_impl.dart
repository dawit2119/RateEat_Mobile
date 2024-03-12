import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/nearby_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/entities/nearby_restaurants_response.dart';

import '../../domain/repositories/nearby_repository.dart';

class NearByRestaurantsRepoImpl extends NearbyRestaurantsRepo {
  final NearByDataProvider nearByDataProvider;
  NearByRestaurantsRepoImpl({required this.nearByDataProvider});
  @override
  Future<Either<Failure, NearbyRestaurantsResponse>> getNearbyRestaurants(
    double lat,
    double lng,
    List<String> tags,
    int page,
    int limit,
  ) async {
    try {
      final res = await nearByDataProvider.getNearByRestaurants(
        lat,
        lng,
        tags,
        page,
        limit,
      );
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
