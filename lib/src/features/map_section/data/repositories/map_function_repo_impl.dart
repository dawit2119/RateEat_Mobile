import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/core/error/map_exception_to_failure.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data_sources/fetch_all_restaurants_dp.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/repositories/map_function_repo.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/all_restaurants_bloc.dart';

class MapFunctionRepoImpl implements MapFunctionRepo {
  final AllRestaurantsDataProvider allRestaurantsDataProvider;

  MapFunctionRepoImpl({required this.allRestaurantsDataProvider});

  @override
  Future<Either<Failure, AllRestaurantsSuccess>> fetchAllRestaurants({
    required int limit,
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    try {
      var allRestaurants = await allRestaurantsDataProvider.fetchAllRestaurants(
        limit: limit,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
      return Right(AllRestaurantsSuccess(restaurants: allRestaurants));
    } catch (error) {
      return Left(mapExceptionToFailure(exception: error));
    }
  }
}
