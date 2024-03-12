import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/all_restaurants_bloc.dart';

import '../../../../core/error/failure.dart';

abstract class MapFunctionRepo {
  Future<Either<Failure, AllRestaurantsSuccess>> fetchAllRestaurants({
    required int limit,
    required double latitude,
    required double longitude,
    required double radius,
  });
}
