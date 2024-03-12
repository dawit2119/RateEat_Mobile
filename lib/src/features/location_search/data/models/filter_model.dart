import 'package:rateeat_mobile/src/features/location_search/domain/entities/filter.dart';

class FilterModel extends Filter {
  const FilterModel({
    required super.tags,
    required super.latitude,
    required super.longitude,
    required super.maxPrice,
    required super.minPrice,
    required super.distanceToTravel,
    required super.rating,
  });

  FilterModel copyWith({
    List<String>? tags,
    double? latitude,
    double? longitude,
    double? maxPrice,
    double? minPrice,
    double? distanceToTravel,
    double? rating,
  }) {
    return FilterModel(
      tags: tags ?? this.tags,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      maxPrice: maxPrice ?? this.maxPrice,
      minPrice: minPrice ?? this.minPrice,
      distanceToTravel: distanceToTravel ?? this.distanceToTravel,
      rating: rating ?? this.rating,
    );
  }
}
