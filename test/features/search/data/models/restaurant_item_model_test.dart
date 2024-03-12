import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/search_result/data/models/restaurant_item_model.dart';

void main() {
  group('RestaurantItemModel', () {
    test('should create a valid instance from a map', () {
      final data = {
        'id': '1',
        'name': 'Test Item',
        'description': 'Delicious food',
        'number_of_reviews': 10,
        'item_tags': [],
        'average_rating': 4.5,
        'price': 12.99,
        'category_id': '123',
        'fasting': true,
        'popularity_index': 5,
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-02T00:00:00.000Z',
        'categories': null,
      };

      final item = RestaurantItemModel.fromMap(data);

      expect(item, isA<RestaurantItemModel>());
      expect(item.name, equals('Test Item'));
      expect(item.averageRating, equals(4.5));
    });

    test('should convert to and from JSON correctly', () {
      final item = RestaurantItemModel(
        id: '1',
        name: 'Test Item',
        description: 'Delicious food',
        numberOfReviews: 10,
        averageRating: 4.5,
        price: 12.99,
        categoryId: '123',
        fasting: true,
        popularityIndex: 5,
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );

      final jsonString = item.toJson();
      final newItem = RestaurantItemModel.fromJson(jsonString);

      expect(newItem, equals(item));
    });
  });
}
