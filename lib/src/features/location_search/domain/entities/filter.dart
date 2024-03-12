import 'package:equatable/equatable.dart';

class Filter extends Equatable {
  final List<String> tags;
  final double latitude;
  final double longitude;
  final double maxPrice;
  final double minPrice;
  final double distanceToTravel;
  final double rating;

  const Filter({
    required this.tags,
    required this.latitude,
    required this.longitude,
    required this.maxPrice,
    required this.minPrice,
    required this.distanceToTravel,
    required this.rating,
  });

  @override
  List<Object?> get props => [
        tags,
        latitude,
        longitude,
        maxPrice,
        minPrice,
        distanceToTravel,
        rating,
      ];
}
