import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';

import '../../../discover/domain/repositories/discover_repo.dart';
import '../../../discover/data/data.dart';

class DiscoverRepoImpl implements DiscoverRepo {
  final LocationDataProvider locationDataProvider;

  DiscoverRepoImpl({
    required this.locationDataProvider,
  });

  @override
  Future<Either<Failure, LocationModel>> getLocation() async {
    try {
      final location = await locationDataProvider.determinePosition();
      // print("Location ${location.toString()}");
      return Right(location);
    } catch (error) {
      return Left(NetworkFailure(errorMessage: error.toString()));
    }
  }
}
