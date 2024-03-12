import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('RecommendedRestaurantTagModel Tests', () {
    late RecommendedRestaurantTagModel tagModel;

    setUp(() {
      tagModel = RecommendedRestaurantTagModel(
        id: '1',
        name: 'Vegan',
      );
    });

    test('should create a RecommendedRestaurantTagModel instance', () {
      expect(tagModel.id, '1');
      expect(tagModel.name, 'Vegan');
    });

    test('should convert RecommendedRestaurantTagModel to JSON', () {
      final json = tagModel.toJson();

      expect(json['id'], tagModel.id);
      expect(json['name'], tagModel.name);
    });

    test('should create RecommendedRestaurantTagModel from JSON', () {
      final json = {
        'id': '2',
        'name': 'Gluten-Free',
      };

      final newTag = RecommendedRestaurantTagModel.fromJson(json);

      expect(newTag.id, '2');
      expect(newTag.name, 'Gluten-Free');
    });

    test('should handle null values when creating from JSON', () {
      final json = {
        'id': null,
        'name': null,
      };

      final newTag = RecommendedRestaurantTagModel.fromJson(json);

      expect(newTag.id, '');
      expect(newTag.name, '');
    });
  });
}
