import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_request.dart';

void main() {
  group('NearByItemRequest', () {
    const tRestaurantId = 'rest123';
    const tItemName = 'Burger';
    const tPage = 1;
    const tLimit = 10;

    final fullRequest = NearByItemRequest(
      restaurantId: tRestaurantId,
      itemName: tItemName,
      page: tPage,
      limit: tLimit,
    );
    final minimalRequest = NearByItemRequest(
      restaurantId: tRestaurantId,
      itemName: tItemName,
      page: tPage,
    );

    group('constructor', () {
      test('should create instance with all properties', () {
        expect(fullRequest.restaurantId, tRestaurantId);
        expect(fullRequest.itemName, tItemName);
        expect(fullRequest.page, tPage);
        expect(fullRequest.limit, tLimit);
      });

      test('should create instance with null limit when not provided', () {
        expect(minimalRequest.restaurantId, tRestaurantId);
        expect(minimalRequest.itemName, tItemName);
        expect(minimalRequest.page, tPage);
        expect(minimalRequest.limit, isNull);
      });
    });

    group('equality', () {
      test('should not be equal when properties differ', () {
        final differentRestaurantId = NearByItemRequest(
          restaurantId: 'rest456',
          itemName: tItemName,
          page: tPage,
          limit: tLimit,
        );
        final differentItemName = NearByItemRequest(
          restaurantId: tRestaurantId,
          itemName: 'Pizza',
          page: tPage,
          limit: tLimit,
        );
        final differentPage = NearByItemRequest(
          restaurantId: tRestaurantId,
          itemName: tItemName,
          page: 2,
          limit: tLimit,
        );
        final differentLimit = NearByItemRequest(
          restaurantId: tRestaurantId,
          itemName: tItemName,
          page: tPage,
          limit: 20,
        );

        expect(fullRequest, isNot(equals(differentRestaurantId)));
        expect(fullRequest, isNot(equals(differentItemName)));
        expect(fullRequest, isNot(equals(differentPage)));
        expect(fullRequest, isNot(equals(differentLimit)));
      });

      test('should not be equal when limit differs (null vs non-null)', () {
        expect(fullRequest, isNot(equals(minimalRequest)));
      });
    });
  });
}
