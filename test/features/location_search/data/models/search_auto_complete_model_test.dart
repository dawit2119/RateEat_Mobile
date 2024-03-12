import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/search_autocomplete_model.dart';

void main() {
  group('SearchAutoCompleteModel', () {
    const description = 'Addis Ababa';
    const placeId = '123';
    const name = 'Addis Ababa';
    const latitude = '9.03';
    const longitude = '38.74';

    test('should create an instance from JSON', () {
      final json = {
        'display_name': description,
        'place_id': placeId,
        'name': name,
        'lat': latitude,
        'lon': longitude,
      };

      final model = SearchAutoCompleteModel.fromJson(json);

      expect(model.description, description);
      expect(model.placeId, placeId);
      expect(model.name, name);
      expect(model.latitude, latitude);
      expect(model.longitude, longitude);
    });

    test('should convert an instance to JSON', () {
      final model = SearchAutoCompleteModel(
        description: description,
        placeId: placeId,
        name: name,
        latitude: latitude,
        longitude: longitude,
      );

      final json = model.toJson();

      expect(json['description'], description);
      expect(json['place_id'], placeId);
    });
  });
}
