import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/discover/data/models/location_model.dart';

abstract class DiscoverRepo {
  Future<Either<Failure, LocationModel>> getLocation();
}
