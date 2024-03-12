import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/menu.dart';

void main() {
  group('DiscoverRestaurantResultModel', () {
    test('should create an instance with given properties', () {
      final model = DiscoverRestaurantResultModel(
        id: '1',
        name: 'Pizza Place',
        openingHour: '08:00',
        closingHour: '22:00',
        isOpen: true,
        averagePrice: 25.0,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 250.0,
        userId: 'user123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        restaurantPhoneNumbers: [],
        menu: Menu(),
        restaurantTags: [],
        restaurantImages: [],
        restaurantVideos: [],
        restaurantLocations: [],
        distance: 1.5,
        walkingTime: '15 min',
        ridingTime: '5 min',
        items: [],
      );

      expect(model.id, '1');
      expect(model.name, 'Pizza Place');
      expect(model.openingHour, '08:00');
      expect(model.closingHour, '22:00');
      expect(model.isOpen, true);
      expect(model.averagePrice, 25.0);
      expect(model.averageRating, 4.5);
      expect(model.numberOfReviews, 100);
      expect(model.popularityIndex, 250.0);
    });

    test('fromJson should create an instance from JSON', () {
      final jsonData = {
        'id': '1',
        'name': 'Pizza Place',
        'opening_hour': '08:00',
        'closing_hour': '22:00',
        'is_open': true,
        'average_price': 25.0,
        'average_rating': 4.5,
        'number_of_reviews': 100,
        'popularity_index': 250.0,
        'user_id': 'user123',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'restaurant_phone_numbers': [],
        'menu': <String, dynamic>{},
        'restaurant_tags': [],
        'restaurant_images': [],
        'restaurant_videos': [],
        'restaurant_locations': [],
        'distance': 1.5,
        'walking_time': '15 min',
        'riding_time': '5 min',
        'items': [],
      };

      final model = DiscoverRestaurantResultModel.fromJson(jsonData);

      expect(model.id, '1');
      expect(model.name, 'Pizza Place');
      expect(model.averagePrice, 25.0);
      expect(model.averageRating, 4.5);
    });

    test('copyWith should create a new instance with updated values', () {
      const model = DiscoverRestaurantResultModel(
        id: '1',
        name: 'Pizza Place',
        averagePrice: 25.0,
        averageRating: 4.5,
      );

      final updatedModel =
          model.copyWith(name: 'Burger Joint', averagePrice: 30.0);

      expect(updatedModel.id, '1');
      expect(updatedModel.name, 'Burger Joint');
      expect(updatedModel.averagePrice, 30.0);
      expect(updatedModel.averageRating, 4.5);
    });

    test('equality operator should work correctly', () {
      const model1 =
          DiscoverRestaurantResultModel(id: '1', name: 'Pizza Place');
      const model2 =
          DiscoverRestaurantResultModel(id: '1', name: 'Pizza Place');
      const model3 =
          DiscoverRestaurantResultModel(id: '2', name: 'Burger Joint');

      expect(model1, model2); // They should be equal
      expect(model1, isNot(model3)); // They should not be equal
    });
  });
}
