import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rateeat_mobile/src/features/discover/data/models/location_model.dart';

void main() {
  group('LocationModel', () {
    const double latitude = 40.7128;
    const double longitude = -74.0060;
    const LatLng latLng = LatLng(latitude, longitude);
    final Position position = Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 1.0,
        heading: 1.0,
        speed: 1.0,
        speedAccuracy: 1.0,
        headingAccuracy: 1.0,
        altitudeAccuracy: 1.0);

    test('LocationModel can be created from latitude and longitude', () {
      const location = LocationModel(latitude: latitude, longitude: longitude);
      expect(location.latitude, latitude);
      expect(location.longitude, longitude);
    });

    test('LocationModel can be created from LatLng', () {
      final location = LocationModel.fromLatLgt(latLng);
      expect(location.latitude, latitude);
      expect(location.longitude, longitude);
    });

    test('LocationModel can be created from Position', () {
      final location = LocationModel.fromPosition(position);
      expect(location.latitude, latitude);
      expect(location.longitude, longitude);
    });

    test('toString returns correct string representation', () {
      const location = LocationModel(latitude: latitude, longitude: longitude);
      expect(location.toString(),
          'Location(latitude: $latitude, longitude: $longitude)');
    });

    test('toLatLng returns correct LatLng object', () {
      const location = LocationModel(latitude: latitude, longitude: longitude);
      final latLngResult = location.toLatLng();
      expect(latLngResult.latitude, latitude);
      expect(latLngResult.longitude, longitude);
    });
  });
}
