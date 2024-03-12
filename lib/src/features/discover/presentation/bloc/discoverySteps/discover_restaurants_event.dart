//* Event
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();
  @override
  List<Object?> get props => [];
}

class StartDiscoverFlowEvent extends DiscoverEvent {
  const StartDiscoverFlowEvent();
  @override
  List<Object?> get props => [];
}

class DiscoveryFilterUpdate extends DiscoverEvent {
  final List<String>? tags;
  final double? latitude;
  final double? longitude;
  final double? maxPrice;
  final double? minPrice;
  final double? distanceToTravel;
  final double? minRating;
  final bool? fasting;
  final String? searchQuery;
  final String? sorting;
  final int page;
  final int? maxTravelTime;
  final TransportMode? transportMode;

  const DiscoveryFilterUpdate({
    this.tags,
    this.latitude,
    this.longitude,
    this.maxPrice,
    this.minPrice,
    this.distanceToTravel,
    this.minRating,
    this.fasting,
    this.searchQuery,
    this.sorting,
    this.page = 1,
    this.maxTravelTime,
    this.transportMode,
  });

  @override
  List<Object?> get props => [
        tags,
        latitude,
        longitude,
        maxPrice,
        minPrice,
        distanceToTravel,
        minRating,
        fasting,
        searchQuery,
        sorting,
        page,
        maxTravelTime,
        transportMode
      ];
}

class FetchDiscoverRestaurant extends DiscoverEvent {
  final double latitude;
  final double longitude;
  final double radius;
  final double maxPrice;
  final double minRating;
  final int limit;
  final List<String> tags;

  const FetchDiscoverRestaurant({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.maxPrice,
    required this.minRating,
    required this.limit,
    required this.tags,
  });

  @override
  List<Object> get props => [
        latitude,
        longitude,
        radius,
        maxPrice,
        minRating,
        limit,
        tags,
      ];
}
