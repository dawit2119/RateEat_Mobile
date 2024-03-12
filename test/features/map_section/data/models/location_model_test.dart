import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('MapLocationModel Tests', () {
    test('fromLatLgt creates MapLocationModel from LatLng', () {
      // Arrange
      final latLng = LatLng(12.34, 56.78);

      // Act
      final location = MapLocationModel.fromLatLgt(latLng);

      // Assert
      expect(location.latitude, 12.34);
      expect(location.longitude, 56.78);
    });

    test('fromPosition creates MapLocationModel from Position', () {
      // Arrange
      final position = Position(
        latitude: 12.34,
        longitude: 56.78,
        accuracy: 100,
        altitude: 1000,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        headingAccuracy: 0,
        timestamp: DateTime.now(),
        altitudeAccuracy: 0,
      );

      // Act
      final location = MapLocationModel.fromPosition(position);

      // Assert
      expect(location.latitude, 12.34);
      expect(location.longitude, 56.78);
    });

    test('toString returns correct string representation', () {
      // Arrange
      final location = MapLocationModel(latitude: 12.34, longitude: 56.78);

      // Act
      final result = location.toString();

      // Assert
      expect(result, 'Location (latitude: 12.34, longitude: 56.78)');
    });

    test('toLatLng returns correct LatLng', () {
      // Arrange
      final location = MapLocationModel(latitude: 12.34, longitude: 56.78);

      // Act
      final latLng = location.toLatLng();

      // Assert
      expect(latLng.latitude, 12.34);
      expect(latLng.longitude, 56.78);
    });
  });
}
