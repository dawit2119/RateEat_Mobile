import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('RecommendedRestaurantEntity Tests', () {
    late RecommendedRestaurantEntity restaurant;

    setUp(() {
      restaurant = RecommendedRestaurantEntity(
        id: '1',
        name: 'Italian Bistro',
        openingHour: '10:00 AM',
        closingHour: '10:00 PM',
        isOpen: true,
        averagePrice: 15.99,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 1,
        userId: 'user1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        distance: '1 km',
        walkingTime: '15 mins',
        ridingTime: '5 mins',
        doShowAvailabilityAlert: true,
        currencyCode: 'ETB',
        restaurantOrderServiceAvailable: true,
        restaurantOrderServiceOnline: false,
      );
    });

    test('should create a RecommendedRestaurantEntity instance', () {
      expect(restaurant.id, '1');
      expect(restaurant.name, 'Italian Bistro');
      expect(restaurant.openingHour, '10:00 AM');
      expect(restaurant.closingHour, '10:00 PM');
      expect(restaurant.isOpen, true);
      expect(restaurant.averagePrice, 15.99);
      expect(restaurant.averageRating, 4.5);
      expect(restaurant.numberOfReviews, 100);
      expect(restaurant.popularityIndex, 1);
      expect(restaurant.userId, 'user1');
      expect(restaurant.distance, '1 km');
      expect(restaurant.walkingTime, '15 mins');
      expect(restaurant.ridingTime, '5 mins');
      expect(restaurant.doShowAvailabilityAlert, true);
      expect(restaurant.currencyCode, 'ETB');
      expect(restaurant.restaurantOrderServiceAvailable, true);
      expect(restaurant.restaurantOrderServiceOnline, false);
    });

    test('should be equal when all properties are the same', () {
      final anotherRestaurant = RecommendedRestaurantEntity(
        id: '1',
        name: 'Italian Bistro',
        openingHour: '10:00 AM',
        closingHour: '10:00 PM',
        isOpen: true,
        averagePrice: 15.99,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 1,
        userId: 'user1',
        createdAt: restaurant.createdAt,
        updatedAt: restaurant.updatedAt,
        distance: '1 km',
        walkingTime: '15 mins',
        ridingTime: '5 mins',
        doShowAvailabilityAlert: true,
        currencyCode: 'ETB',
        restaurantOrderServiceAvailable: true,
        restaurantOrderServiceOnline: false,
      );

      expect(restaurant, anotherRestaurant);
    });

    test('should not be equal when id is different', () {
      final differentRestaurant = RecommendedRestaurantEntity(
        id: '2',
        name: 'Italian Bistro',
        openingHour: '10:00 AM',
        closingHour: '10:00 PM',
        isOpen: true,
        averagePrice: 15.99,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 1,
        userId: 'user1',
        createdAt: restaurant.createdAt,
        updatedAt: restaurant.updatedAt,
        distance: '1 km',
        walkingTime: '15 mins',
        ridingTime: '5 mins',
        doShowAvailabilityAlert: true,
        currencyCode: 'ETB',
        restaurantOrderServiceAvailable: true,
        restaurantOrderServiceOnline: false,
      );

      expect(restaurant, isNot(equals(differentRestaurant)));
    });

    test('should handle nullable properties correctly', () {
      final restaurantWithNulls = RecommendedRestaurantEntity(
        id: '3',
        name: 'New Restaurant',
        openingHour: null,
        closingHour: null,
        isOpen: null,
        averagePrice: null,
        averageRating: null,
        numberOfReviews: null,
        popularityIndex: null,
        userId: null,
        createdAt: null,
        updatedAt: null,
        distance: '2 km',
        walkingTime: '20 mins',
        ridingTime: '10 mins',
        doShowAvailabilityAlert: false,
        currencyCode: 'ETB',
        restaurantOrderServiceAvailable: false,
        restaurantOrderServiceOnline: false,
      );

      expect(restaurantWithNulls.openingHour, null);
      expect(restaurantWithNulls.closingHour, null);
      expect(restaurantWithNulls.isOpen, null);
    });
  });
}
