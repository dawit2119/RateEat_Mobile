import 'package:equatable/equatable.dart';

import '../../../../core/widgets/distance_field_tabs.dart';

class DiscoverRestaurantModel extends Equatable {
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
  final int maxTravelTime;
  final TransportMode transportMode;

  const DiscoverRestaurantModel({
    this.tags,
    this.latitude,
    this.longitude,
    this.maxPrice,
    this.minPrice,
    this.distanceToTravel,
    this.minRating,
    this.fasting,
    this.searchQuery,
    this.sorting = "",
    this.page = 1,
    this.maxTravelTime = 18,
    this.transportMode = TransportMode.walking,
  });

  DiscoverRestaurantModel copyWith(
      {List<String>? tags,
      double? latitude,
      double? longitude,
      double? maxPrice,
      double? minPrice,
      double? distanceToTravel,
      double? minRating,
      bool? fasting,
      String? searchQuery,
      String? sorting,
      int? page,
      int? maxTravelTime,
      TransportMode? transportMode}) {
    return DiscoverRestaurantModel(
      tags: tags ?? this.tags,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      maxPrice: maxPrice ?? this.maxPrice,
      minPrice: minPrice ?? this.minPrice,
      distanceToTravel: distanceToTravel ?? this.distanceToTravel,
      minRating: minRating ?? this.minRating,
      fasting: fasting ?? this.fasting,
      searchQuery: searchQuery ?? this.searchQuery,
      sorting: sorting ?? this.sorting,
      page: page ?? this.page,
      maxTravelTime: maxTravelTime ?? this.maxTravelTime,
      transportMode: transportMode ?? this.transportMode,
    );
  }

  @override
  String toString() =>
      "tags: $tags latitude: $latitude longitude: $longitude maxPrice: $maxPrice minPrice: $minPrice distanceToTravel: $distanceToTravel rating: $minRating fasting: $fasting searchQuery: $searchQuery sorting: $sorting";

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
        transportMode,
      ];
}
