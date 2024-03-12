import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_tag.dart';

void main() {
  group('RestaurantTag', () {
    test('should create an instance with given properties', () {
      const restaurantTag = RestaurantTag(id: '1', name: 'Vegan');

      expect(restaurantTag.id, '1');
      expect(restaurantTag.name, 'Vegan');
    });

    test('fromJson should create an instance from JSON', () {
      final jsonData = {
        'id': '1',
        'name': 'Vegan',
      };

      final restaurantTag = RestaurantTag.fromJson(jsonData);

      expect(restaurantTag.id, '1');
      expect(restaurantTag.name, 'Vegan');
    });

    test('copyWith should create a new instance with updated values', () {
      const restaurantTag = RestaurantTag(id: '1', name: 'Vegan');

      final updatedTag = restaurantTag.copyWith(name: 'Vegetarian');

      expect(updatedTag.id, '1');
      expect(updatedTag.name, 'Vegetarian');
    });

    test('equality operator should work correctly', () {
      const tag1 = RestaurantTag(id: '1', name: 'Vegan');
      const tag2 = RestaurantTag(id: '1', name: 'Vegan');
      const tag3 = RestaurantTag(id: '2', name: 'Vegetarian');

      expect(tag1, tag2); // They should be equal
      expect(tag1, isNot(tag3)); // They should not be equal
    });
  });
}
