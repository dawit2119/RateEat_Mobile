import 'package:rateeat_mobile/src/features/features.dart';
import 'package:test/test.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/entities/nearby_restaurants_response.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/near_by_restaurants_response_model.dart';

void main() {
  group('NearbyRestaurantsResponseModel', () {
    test('Creation and properties', () {
      final model = NearbyRestaurantsResponseModel(
        restaurants: const [
          RestaurantModel(
            id: 'rest1',
            name: 'Restaurant 1',
          )
        ],
        totalItems: 2,
      );
      expect(model.restaurants,
          [const RestaurantModel(id: 'rest1', name: 'Restaurant 1')]);
      expect(model.totalItems, 2);
      expect(model is NearbyRestaurantsResponse, true);
    });

    test('Empty list', () {
      final model = NearbyRestaurantsResponseModel(
        restaurants: [],
        totalItems: 0,
      );
      expect(model.restaurants, isEmpty);
      expect(model.totalItems, 0);
    });
  });
}
