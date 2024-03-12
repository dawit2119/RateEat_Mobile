import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';

void main() {
  group('DiscoverEvent', () {
    test('StartDiscoverFlowEvent should have correct props', () {
      const event = StartDiscoverFlowEvent();
      expect(event.props, []);
    });

    test('DiscoveryFilterUpdate should have correct props', () {
      const event = DiscoveryFilterUpdate(
        tags: ['vegan', 'gluten-free'],
        latitude: 10.0,
        longitude: 20.0,
        maxPrice: 50.0,
        minPrice: 10.0,
        distanceToTravel: 5.0,
        minRating: 4.0,
        fasting: true,
        searchQuery: 'pizza',
        sorting: 'rating',
        page: 1,
        maxTravelTime: 30,
        transportMode: TransportMode.driving,
      );

      expect(event.props, [
        event.tags,
        event.latitude,
        event.longitude,
        event.maxPrice,
        event.minPrice,
        event.distanceToTravel,
        event.minRating,
        event.fasting,
        event.searchQuery,
        event.sorting,
        event.page,
        event.maxTravelTime,
        event.transportMode,
      ]);
    });

    test('FetchDiscoverRestaurant should have correct props', () {
      const event = FetchDiscoverRestaurant(
        latitude: 10.0,
        longitude: 20.0,
        radius: 5.0,
        maxPrice: 50.0,
        minRating: 4.0,
        limit: 10,
        tags: ['vegan', 'gluten-free'],
      );

      expect(event.props, [
        event.latitude,
        event.longitude,
        event.radius,
        event.maxPrice,
        event.minRating,
        event.limit,
        event.tags,
      ]);
    });

    test('DiscoveryFilterUpdate equality', () {
      const event1 = DiscoveryFilterUpdate(
        tags: ['vegan'],
        latitude: 10.0,
        longitude: 20.0,
        maxPrice: 50.0,
        minPrice: 10.0,
        distanceToTravel: 5.0,
        minRating: 4.0,
        fasting: true,
        searchQuery: 'pizza',
        sorting: 'rating',
        page: 1,
        maxTravelTime: 30,
        transportMode: TransportMode.driving,
      );

      const event2 = DiscoveryFilterUpdate(
        tags: ['vegan'],
        latitude: 10.0,
        longitude: 20.0,
        maxPrice: 50.0,
        minPrice: 10.0,
        distanceToTravel: 5.0,
        minRating: 4.0,
        fasting: true,
        searchQuery: 'pizza',
        sorting: 'rating',
        page: 1,
        maxTravelTime: 30,
        transportMode: TransportMode.driving,
      );

      expect(event1, event2);
    });

    test('FetchDiscoverRestaurant equality', () {
      const event1 = FetchDiscoverRestaurant(
        latitude: 10.0,
        longitude: 20.0,
        radius: 5.0,
        maxPrice: 50.0,
        minRating: 4.0,
        limit: 10,
        tags: ['vegan'],
      );

      const event2 = FetchDiscoverRestaurant(
        latitude: 10.0,
        longitude: 20.0,
        radius: 5.0,
        maxPrice: 50.0,
        minRating: 4.0,
        limit: 10,
        tags: ['vegan'],
      );

      expect(event1, event2);
    });
  });
}
