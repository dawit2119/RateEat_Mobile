import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';
import '../repositories/discover_restaurant_repo.dart';

class DiscoverRestaurantUseCase extends UseCase<
    List<DiscoverRestaurantResultModel>, DiscoverRestaurantParams> {
  final FetchRestaurantRepo fetchRestaurantRepo;

  DiscoverRestaurantUseCase({required this.fetchRestaurantRepo});

  @override
  Future<Either<Failure, List<DiscoverRestaurantResultModel>>> call(
    DiscoverRestaurantParams params,
  ) async {
    return await fetchRestaurantRepo.getDiscoverRestaurantsResults(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
      maxPrice: params.maxPrice,
      minRating: params.minRating,
      tags: params.tags,
      sorting: params.sorting,
      fasting: params.fasting,
      limit: params.limit,
      page: params.page,
      maxTravelTime: params.maxTravelTime,
      transportMode: params.transportMode,
    );
  }
}

class DiscoverRestaurantParams extends Equatable {
  final double latitude;
  final double longitude;
  final double radius;
  final double maxPrice;
  final double minRating;
  final int limit;
  final List<String> tags;
  final String? searchQuery;
  final String sorting;
  final bool fasting;
  final int page;
  final int maxTravelTime;
  final TransportMode transportMode;

  const DiscoverRestaurantParams({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.maxPrice,
    required this.minRating,
    required this.limit,
    required this.tags,
    required this.fasting,
    this.searchQuery,
    required this.sorting,
    required this.page,
    required this.maxTravelTime,
    required this.transportMode,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        radius,
        maxPrice,
        minRating,
        limit,
        tags,
        searchQuery,
        sorting,
        fasting,
        page,
        maxTravelTime,
        transportMode,
      ];
}
