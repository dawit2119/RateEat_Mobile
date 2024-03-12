import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromLatLgt(LatLng latLng) {
    return Location(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
  }
  factory Location.fromPosition(Position position) {
    return Location(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  factory Location.fromRestaurantLocationModel(
      RestaurantLocationModel locationModel) {
    return Location(
      latitude: locationModel.latitude!,
      longitude: locationModel.longitude!,
    );
  }

  @override
  String toString() => 'Location(latitude: $latitude, longitude: $longitude)';

  LatLng toLatLng() => LatLng(latitude, longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}
