import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';

void main() {
  group('GoogleAutoCompleteModel', () {
    const description = 'Addis Ababa';
    const placeId = '123';

    test('should create an instance from JSON', () {
      final json = {
        'description': description,
        'place_id': placeId,
      };

      final model = GoogleAutoCompleteModel.fromJson(json);

      expect(model.description, description);
      expect(model.placeId, placeId);
    });

    test('should convert an instance to JSON', () {
      final model = GoogleAutoCompleteModel(
        description: description,
        placeId: placeId,
      );

      final json = model.toJson();

      expect(json['description'], description);
      expect(json['place_id'], placeId);
    });
  });
}
