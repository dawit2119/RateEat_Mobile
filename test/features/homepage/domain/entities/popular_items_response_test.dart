import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/popular_items_response.dart';

void main() {
  group('PopularItemsResponse Tests', () {
    late PopularItemsResponse response;
    late List<Item> items;

    setUp(() {
      items = [
        Item(
          itemId: '1',
          itemName: 'Pasta',
          numberOfReviews: 20,
          averageRating: 4.5,
          price: 12.99,
          restaurantName: 'Italian Bistro',
        ),
        Item(
          itemId: '2',
          itemName: 'Pizza',
          numberOfReviews: 15,
          averageRating: 4.0,
          price: 9.99,
          restaurantName: 'Pizza Place',
        ),
      ];

      response = PopularItemsResponse(items: items, totalItems: items.length);
    });

    test('should create a PopularItemsResponse instance', () {
      expect(response.items, items);
      expect(response.totalItems, items.length);
    });

    test('should be equal when items and totalItems are same', () {
      final anotherResponse =
          PopularItemsResponse(items: items, totalItems: items.length);

      expect(response, anotherResponse);
    });

    test('should not be equal when items are different', () {
      final differentItems = [
        Item(
          itemId: '3',
          itemName: 'Salad',
          numberOfReviews: 10,
          averageRating: 5.0,
          price: 7.99,
          restaurantName: 'Healthy Eats',
        ),
      ];

      final differentResponse = PopularItemsResponse(
          items: differentItems, totalItems: differentItems.length);

      expect(response, isNot(equals(differentResponse)));
    });

    test('should handle null totalItems', () {
      final responseWithNullTotal =
          PopularItemsResponse(items: items, totalItems: null);

      expect(responseWithNullTotal.items, items);
      expect(responseWithNullTotal.totalItems, null);
    });
  });
}
