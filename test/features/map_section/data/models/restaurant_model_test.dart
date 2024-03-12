import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('Restaurant Model Tests', () {
    test('Restaurant equality', () {
      const restaurant1 = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        openingHour: '08:00',
        closingHour: '22:00',
        isOpen: true,
        averagePrice: 20.0,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 10,
        distance: '2 km',
        walkingTime: '10 mins',
        ridingTime: '5 mins',
        currencyCode: 'ETB',
      );

      const restaurant2 = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        openingHour: '08:00',
        closingHour: '22:00',
        isOpen: true,
        averagePrice: 20.0,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 10,
        distance: '2 km',
        walkingTime: '10 mins',
        ridingTime: '5 mins',
        currencyCode: 'ETB',
      );

      const restaurant3 = Restaurant(
        id: '2',
        name: 'Another Restaurant',
      );

      // Test equality
      expect(restaurant1, restaurant2);
      expect(restaurant1, isNot(restaurant3));
    });

    test('Restaurant serialization to JSON and back', () {
      const restaurant = RestaurantModel(
        id: '1',
        name: 'Test Restaurant',
        openingHour: '08:00',
        closingHour: '22:00',
        isOpen: true,
        averagePrice: 20.0,
        averageRating: 4.5,
        numberOfReviews: 100,
        popularityIndex: 10,
        distance: '2 km',
        walkingTime: '10 mins',
        ridingTime: '5 mins',
        currencyCode: 'ETB',
      );

      final json = restaurant.toJson();
      final newRestaurant = RestaurantModel.fromJson(json);

      expect(newRestaurant, restaurant);
    });
  });

  group('RestaurantMedia Model Tests', () {
    test('RestaurantMedia equality', () {
      const media1 = RestaurantMedia(
        id: '1',
        url: 'http://example.com/image1.jpg',
        isLeading: true,
      );

      const media2 = RestaurantMedia(
        id: '1',
        url: 'http://example.com/image1.jpg',
        isLeading: true,
      );

      const media3 = RestaurantMedia(
        id: '2',
        url: 'http://example.com/image2.jpg',
      );

      // Test equality
      expect(media1, media2);
      expect(media1, isNot(media3));
    });

    test('RestaurantMedia serialization to JSON and back', () {
      const media = RestaurantMedia(
        id: '1',
        url: 'http://example.com/image1.jpg',
        isLeading: false,
      );

      final json = media.toJson();
      final newMedia = RestaurantMedia.fromJson(json);

      expect(newMedia, media);
    });
  });
}
