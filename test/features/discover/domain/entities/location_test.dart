import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data.dart';

void main() {
  group('Location', () {
    test('should create a Location from latitude and longitude', () {
      const location = Location(latitude: 10.0, longitude: 20.0);
      expect(location.latitude, 10.0);
      expect(location.longitude, 20.0);
    });

    test('should create a Location from LatLng', () {
      final latLng = LatLng(15.0, 25.0);
      final location = Location.fromLatLgt(latLng);
      expect(location.latitude, 15.0);
      expect(location.longitude, 25.0);
    });

    test('should create a Location from Position', () {
      final position = Position(
        latitude: 30.0,
        longitude: 40.0,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 10.0,
        heading: 10.0,
        speed: 10.0,
        speedAccuracy: 10.0,
        headingAccuracy: 10.0,
        altitudeAccuracy: 10.0,
      );

      final location = Location.fromPosition(position);
      expect(location.latitude, 30.0);
      expect(location.longitude, 40.0);
    });

    test('should create a Location from RestaurantLocationModel', () {
      final restaurantLocationModel = RestaurantLocationModel(
        latitude: 50.0,
        longitude: 60.0,
      );
      final location =
          Location.fromRestaurantLocationModel(restaurantLocationModel);
      expect(location.latitude, 50.0);
      expect(location.longitude, 60.0);
    });

    test('should convert Location to LatLng', () {
      const location = Location(latitude: 70.0, longitude: 80.0);
      final latLng = location.toLatLng();
      expect(latLng.latitude, 70.0);
      expect(latLng.longitude, 80.0);
    });

    test('should have correct toString representation', () {
      const location = Location(latitude: 90.0, longitude: 100.0);
      expect(location.toString(), 'Location(latitude: 90.0, longitude: 100.0)');
    });

    test('should be equal when latitude and longitude are the same', () {
      const location1 = Location(latitude: 1.0, longitude: 2.0);
      const location2 = Location(latitude: 1.0, longitude: 2.0);
      expect(location1, location2);
    });

    test('should not be equal when latitude or longitude is different', () {
      const location1 = Location(latitude: 1.0, longitude: 2.0);
      const location2 = Location(latitude: 1.0, longitude: 3.0);
      const location3 = Location(latitude: 2.0, longitude: 2.0);
      expect(location1, isNot(location2));
      expect(location1, isNot(location3));
    });
  });
}
