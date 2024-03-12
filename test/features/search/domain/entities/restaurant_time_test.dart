import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';
import "package:rateeat_mobile/src/features/search_result/domain/entities/restaurant_item.dart";
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';

void main() {
  group('RestaurantItem', () {
    test('should create a valid instance', () {
      final item = RestaurantItem(
        id: '1',
        name: 'Test Item',
        description: 'Delicious food',
        numberOfReviews: 10,
        restaurantName: 'Test Restaurant',
        itemTags: [ItemTag(id: '1', name: 'Spicy')],
        averageRating: 4.5,
        price: 12.99,
        categoryId: '123',
        categories: Categories(id: '123', name: 'Fast Food', menuId: '1'),
        fasting: true,
        popularityIndex: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(item, isA<RestaurantItem>());
      expect(item.name, equals('Test Item'));
      expect(item.averageRating, equals(4.5));
    });

    test('should check equality based on properties', () {
      final item1 = RestaurantItem(id: '1', name: 'Test Item');
      final item2 = RestaurantItem(id: '1', name: 'Test Item');

      expect(item1, equals(item2));
    });
  });
}
