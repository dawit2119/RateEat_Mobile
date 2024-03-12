import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart'; // Adjust the import for the Location class

void main() {
  group('UserLocationEvent', () {
    test('GetUserLocation should have correct props', () {
      const event = GetUserLocation();
      expect(event.props, []);
    });

    test('ChangeUserLocation should have correct props', () {
      const newLocation = Location(latitude: 10.0, longitude: 20.0);
      const event = ChangeUserLocation(newLocation: newLocation);
      expect(event.props, [newLocation]);
    });

    test('ChangeUserLocation equality', () {
      final location1 = Location(latitude: 10.0, longitude: 20.0);
      final location2 = Location(latitude: 10.0, longitude: 20.0);
      final event1 = ChangeUserLocation(newLocation: location1);
      final event2 = ChangeUserLocation(newLocation: location2);

      expect(event1, event2);
    });

    test('ChangeUserLocation should not be equal with different locations', () {
      final location1 = Location(latitude: 10.0, longitude: 20.0);
      final location2 = Location(latitude: 30.0, longitude: 40.0);
      final event1 = ChangeUserLocation(newLocation: location1);
      final event2 = ChangeUserLocation(newLocation: location2);

      expect(event1, isNot(event2));
    });
  });
}
