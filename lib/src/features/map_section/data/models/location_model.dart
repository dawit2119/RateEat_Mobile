import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rateeat_mobile/src/features/discover/domain/entities/location.dart';

class MapLocationModel extends Location {
  const MapLocationModel({required super.latitude, required super.longitude});

  factory MapLocationModel.fromLatLgt(LatLng latLng) {
    return MapLocationModel(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
  }
  factory MapLocationModel.fromPosition(Position position) {
    return MapLocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  String toString() => 'Location (latitude: $latitude, longitude: $longitude)';

  @override
  LatLng toLatLng() => LatLng(latitude, longitude);
}
