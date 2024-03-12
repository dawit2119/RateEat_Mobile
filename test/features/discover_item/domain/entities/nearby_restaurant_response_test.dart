import 'package:test/test.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/entities/nearby_restaurants_response.dart';

void main() {
  group('NearbyRestaurantsResponse', () {
    test('Creation', () {
      const response =
          NearbyRestaurantsResponse(restaurants: [], totalItems: 0);
      expect(response.restaurants, []);
      expect(response.totalItems, 0);
    });

    test('Equality', () {
      const response1 =
          NearbyRestaurantsResponse(restaurants: [], totalItems: 0);
      const response2 =
          NearbyRestaurantsResponse(restaurants: [], totalItems: 0);
      expect(response1, equals(response2));
    });
  });
}
