import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

abstract class LocationBasedRestaurantsRepository {
  Future<Either<Failure, int>> getRestaurantsBasedOnLocation(
      {required double lat, required double long, required double radius});
}
