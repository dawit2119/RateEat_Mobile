import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('RecommendedRestaurantTagEntity Tests', () {
    late RecommendedRestaurantTagEntity tag;

    setUp(() {
      tag = RecommendedRestaurantTagEntity(
        id: 'tag1',
        name: 'Vegan',
      );
    });

    test('should create a RecommendedRestaurantTagEntity instance', () {
      expect(tag.id, 'tag1');
      expect(tag.name, 'Vegan');
    });

    test('should be equal when all properties are the same', () {
      final anotherTag = RecommendedRestaurantTagEntity(
        id: 'tag1',
        name: 'Vegan',
      );

      expect(tag, anotherTag);
    });

    test('should not be equal when id is different', () {
      final differentTag = RecommendedRestaurantTagEntity(
        id: 'tag2',
        name: 'Vegan',
      );
      ;

      expect(tag, isNot(equals(differentTag)));
    });

    test('should not be equal when name is different', () {
      final differentTag = RecommendedRestaurantTagEntity(
        id: 'tag1',
        name: 'Vegetarian',
      );
      ;

      expect(tag, isNot(equals(differentTag)));
    });

    test('should handle nullable properties correctly', () {
      final tagWithNulls = RecommendedRestaurantTagEntity(
        id: null,
        name: null,
      );

      expect(tagWithNulls.id, null);
      expect(tagWithNulls.name, null);
    });
  });
}
