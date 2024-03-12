import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_phone_number.dart';
import 'package:rateeat_mobile/src/features/features.dart';

List<Restaurant> dummyRestaurants = [
  Restaurant(
      id: "R001",
      name: "Sunset Grill",
      openingHour: "08:00:00",
      closingHour: "22:00:00",
      isOpen: true,
      averagePrice: 25.50,
      averageRating: 4.5,
      numberOfReviews: 150,
      popularityIndex: 1,
      distance: "2.5",
      walkingTime: "30 min",
      ridingTime: "10 min",
      userId: "U100",
      createdAt: DateTime.parse("2022-01-01"),
      updatedAt: DateTime.parse("2022-06-01"),
      restaurantTags: const [
        RestaurantTagModel(name: "Grill"),
        RestaurantTagModel(name: "Family")
      ],
      restaurantImages: [
        RestaurantMedia(
            id: '123',
            url: 'https://example.com/caesar_salad.jpg',
            isLeading: false)
      ],
      restaurantVideos: [
        RestaurantMedia(
            id: '123',
            url: 'https://example.com/caesar_salad.jpg',
            isLeading: false)
      ],
      restaurantLocations: const [
        RestaurantLocationModel(
            latitude: 9, longitude: 38, description: "Arat Kilo")
      ],
      restaurantPhoneNumbers: [
        RestaurantPhoneNumber(phoneNumber: "+1234567890", id: '123')
      ]),
  Restaurant(
      id: "R002",
      name: "Morning Java",
      openingHour: "05:00:00",
      closingHour: "18:00:00",
      isOpen: false,
      averagePrice: 15.00,
      averageRating: 4.0,
      numberOfReviews: 200,
      popularityIndex: 2,
      distance: "1",
      walkingTime: "12 min",
      ridingTime: "3 min",
      userId: "U101",
      createdAt: DateTime.parse("2022-02-15"),
      updatedAt: DateTime.parse("2022-07-15"),
      restaurantTags: const [
        RestaurantTagModel(name: "Cafe"),
        RestaurantTagModel(name: "Cozy")
      ],
      restaurantImages: [
        RestaurantMedia(
            id: '123',
            url: 'https://example.com/caesar_salad.jpg',
            isLeading: false)
      ],
      restaurantVideos: [
        RestaurantMedia(
            id: '123',
            url: 'https://example.com/caesar_salad.jpg',
            isLeading: false)
      ],
      restaurantLocations: const [
        RestaurantLocationModel(
            latitude: 9, longitude: 38, description: "Sidst Kilo")
      ],
      restaurantPhoneNumbers: [
        RestaurantPhoneNumber(phoneNumber: "+1234567890", id: '123')
      ]),
];
