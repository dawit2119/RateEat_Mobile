import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({required super.latitude, required super.longitude});

  factory LocationModel.fromLatLgt(LatLng latLng) {
    return LocationModel(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
  }
  factory LocationModel.fromPosition(Position position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  String toString() => 'Location(latitude: $latitude, longitude: $longitude)';

  @override
  LatLng toLatLng() => LatLng(latitude, longitude);
}
