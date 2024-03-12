import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/location_coordinate_model.dart';

void main() {
  group('LocationCoordinateModel', () {
    const name = 'Addis Ababa';
    const latitude = 9.03;
    const longitude = 38.74;

    test('should create an instance from JSON', () {
      final json = {
        'name': name,
        'geometry': {
          'location': {
            'lat': latitude,
            'lng': longitude,
          }
        }
      };

      final model = LocationCoordinateModel.fromJson(json);

      expect(model.name, name);
      expect(model.latitude, latitude);
      expect(model.longitude, longitude);
    });

    test('should handle missing name gracefully', () {
      final json = {
        'geometry': {
          'location': {
            'lat': latitude,
            'lng': longitude,
          }
        }
      };

      final model = LocationCoordinateModel.fromJson(json);

      expect(model.name, '');
      expect(model.latitude, latitude);
      expect(model.longitude, longitude);
    });
  });
}
