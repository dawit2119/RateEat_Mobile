import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('RecommendedRestaurantModel Tests', () {
    late RecommendedRestaurantModel restaurantModel;

    setUp(() {
      restaurantModel = RecommendedRestaurantModel(
        id: '1',
        name: 'Test Restaurant',
        openingHour: '08:00',
        closingHour: '22:00',
        isOpen: true,
        averagePrice: 20.0,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 5,
        userId: 'user123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        distance: '1.5 km',
        walkingTime: '15 mins',
        ridingTime: '5 mins',
        restaurantTags: [],
        restaurantImages: [],
        restaurantVideos: [],
        restaurantLocations: [],
        restaurantReviews: [],
        restaurantPhoneNumbers: [],
        doShowAvailabilityAlert: false,
        currencyCode: 'ETB',
        restaurantOrderServiceAvailable: true,
        restaurantOrderServiceOnline: false,
      );
    });

    test('should create a RecommendedRestaurantModel instance', () {
      expect(restaurantModel.id, '1');
      expect(restaurantModel.name, 'Test Restaurant');
      expect(restaurantModel.openingHour, '08:00');
      expect(restaurantModel.closingHour, '22:00');
      expect(restaurantModel.isOpen, true);
      expect(restaurantModel.averagePrice, 20.0);
      expect(restaurantModel.averageRating, 4.5);
      expect(restaurantModel.numberOfReviews, 100);
    });

    test('should convert RecommendedRestaurantModel to JSON', () {
      final json = restaurantModel.toJson();

      expect(json['id'], restaurantModel.id);
      expect(json['name'], restaurantModel.name);
      expect(json['opening_hour'], restaurantModel.openingHour);
      expect(json['closing_hour'], restaurantModel.closingHour);
      expect(json['is_open'], restaurantModel.isOpen);
      expect(json['average_price'], restaurantModel.averagePrice);
      expect(json['average_rating'], restaurantModel.averageRating);
      expect(json['number_of_reviews'], restaurantModel.numberOfReviews);
    });

    test('should create RecommendedRestaurantModel from JSON', () {
      final json = {
        'id': '2',
        'name': 'Another Restaurant',
        'opening_hour': '10:00',
        'closing_hour': '23:00',
        'is_open': false,
        'average_price': 15.0,
        'average_rating': 4.0,
        'number_of_reviews': 50,
        'popularity_index': 2,
        'user_id': 'user456',
        'distance': '0.5 km',
        'walking_time': '10 mins',
        'riding_time': '3 mins',
        'restaurant_tags': [],
        'restaurant_images': [],
        'restaurant_videos': [],
        'restaurant_locations': [],
        'restaurant_reviews': [],
        'restaurant_phone_numbers': [],
        'availability_alert': true,
        'is_order_service_available': true,
        'is_order_service_online': false,
      };

      final newRestaurant = RecommendedRestaurantModel.fromJson(json);

      expect(newRestaurant.id, '2');
      expect(newRestaurant.name, 'Another Restaurant');
      expect(newRestaurant.openingHour, '10:00');
      expect(newRestaurant.closingHour, '23:00');
      expect(newRestaurant.isOpen, false);
      expect(newRestaurant.averagePrice, 15.0);
      expect(newRestaurant.averageRating, 4.0);
      expect(newRestaurant.numberOfReviews, 50);
    });

    test('should handle null values when creating from JSON', () {
      final json = {
        'id': null,
        'name': null,
        'opening_hour': null,
        'closing_hour': null,
        'is_open': null,
        'average_price': null,
        'average_rating': null,
        'number_of_reviews': null,
        'popularity_index': null,
        'user_id': null,
        'distance': null,
        'walking_time': null,
        'riding_time': null,
        'restaurant_tags': null,
        'restaurant_images': null,
        'restaurant_videos': null,
        'restaurant_locations': null,
        'restaurant_reviews': null,
        'restaurant_phone_numbers': null,
        'availability_alert': null,
        'is_order_service_available': null,
        'is_order_service_online': null,
      };

      final newRestaurant = RecommendedRestaurantModel.fromJson(json);

      expect(newRestaurant.id, '');
      expect(newRestaurant.name, '');
      expect(newRestaurant.isOpen, false);
      expect(newRestaurant.averagePrice, 0.0);
      expect(newRestaurant.averageRating, 0.0);
      expect(newRestaurant.numberOfReviews, 0);
    });
  });
}
