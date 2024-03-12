import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/repositories/location_based_restaurant_repo.dart';

class LocationBasedRestaurantUseCase
    extends UseCase<int, LocationBasedRestaurantParams> {
  final LocationBasedRestaurantsRepository repository;

  LocationBasedRestaurantUseCase({required this.repository});

  @override
  Future<Either<Failure, int>> call(
      LocationBasedRestaurantParams params) async {
    return await repository.getRestaurantsBasedOnLocation(
        lat: params.lat, long: params.long, radius: params.radius);
  }
}

class LocationBasedRestaurantParams extends Equatable {
  final double lat;
  final double long;
  final double radius;

  const LocationBasedRestaurantParams(
      {required this.lat, required this.long, required this.radius});

  @override
  List<Object?> get props => [lat, long, radius];
}
