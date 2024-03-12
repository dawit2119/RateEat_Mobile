import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data_sources/location_based_restaurants_dp.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/repositories/location_based_restaurant_repo.dart';

class LocationBasedRestaurantsRepositoryImpl
    implements LocationBasedRestaurantsRepository {
  final LocationRestaurantsRemoteSource remoteSource;

  LocationBasedRestaurantsRepositoryImpl({
    required this.remoteSource,
  });

  @override
  Future<Either<Failure, int>> getRestaurantsBasedOnLocation(
      {required double lat,
      required double long,
      required double radius}) async {
    try {
      final count = await remoteSource.getRestaurantsBasedOnLocation(
          lat: lat, long: long, radius: radius);
      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    }
  }
}
