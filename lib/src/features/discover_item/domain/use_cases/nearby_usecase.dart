import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/entities/nearby_restaurants_response.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/nearby_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class NearbyUseCase {
  final NearbyRestaurantsRepo nearbyRestaurantsRepo;
  NearbyUseCase({required this.nearbyRestaurantsRepo});

  Future<Either<Failure, NearbyRestaurantsResponse>> getNearbyRestaurants(
      double lat, double lng, List<String> tags, int page, int limit) async {
    return nearbyRestaurantsRepo.getNearbyRestaurants(
        lat, lng, tags, page, limit);
  }
}

class GetNearbyUseCaseParams extends Equatable {
  final double lat;
  final double lng;
  final List<String> tags;
  final int page;
  final int limit;

  const GetNearbyUseCaseParams({
    required this.lat,
    required this.lng,
    required this.tags,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [lat, lng, tags, page, limit];
}
