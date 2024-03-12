import 'package:rateeat_mobile/src/features/map_section/data/models/restaurant_location_model.dart';
import 'package:rateeat_mobile/src/features/map_section/data/models/restaurant_model.dart';
import 'package:rateeat_mobile/src/features/map_section/data/models/restaurant_tag_model.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_phone_number.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/entities/restaurant.dart';

import 'helper.dart';

List<RestaurantModel> dummyRestaurants = [
  RestaurantModel(
    id: '1',
    name: 'The Golden Spoon',
    openingHour: '09:00',
    closingHour: '22:00',
    isOpen: true,
    averagePrice: 25.0,
    averageRating: 4.5,
    numberOfReviews: 150,
    popularityIndex: 1,
    userId: 'user_001',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    distance: '1.5 km',
    walkingTime: '20 mins',
    ridingTime: '5 mins',
    restaurantTags: const [RestaurantTagModel(id: 'tag_1', name: 'Cozy')],
    restaurantImages: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantVideos: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantLocations: const [
      RestaurantLocationModel(
          id: 'loc_1', latitude: 40.712776, longitude: -74.005974)
    ],
    restaurantPhoneNumbers: [
      RestaurantPhoneNumber(phoneNumber: '+1234567890', id: '12')
    ],
  ),
  RestaurantModel(
    id: '2',
    name: 'Spice Heaven',
    openingHour: '10:00',
    closingHour: '23:00',
    isOpen: false,
    averagePrice: 30.0,
    averageRating: 4.8,
    numberOfReviews: 200,
    popularityIndex: 2,
    userId: 'user_002',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    distance: '3 km',
    walkingTime: '35 mins',
    ridingTime: '10 mins',
    restaurantTags: const [
      RestaurantTagModel(id: 'tag_2', name: 'Indian Cuisine')
    ],
    restaurantImages: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantVideos: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantLocations: const [
      RestaurantLocationModel(
          id: 'loc_2', latitude: 40.713776, longitude: -74.015974)
    ],
    restaurantPhoneNumbers: [
      RestaurantPhoneNumber(phoneNumber: '+1234567890', id: '12')
    ],
  ),
  RestaurantModel(
    id: '3',
    name: 'Burger Joint',
    openingHour: '11:00',
    closingHour: '21:00',
    isOpen: true,
    averagePrice: 15.0,
    averageRating: 4.2,
    numberOfReviews: 120,
    popularityIndex: 3,
    userId: 'user_003',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    distance: '0.5 km',
    walkingTime: '7 mins',
    ridingTime: '2 mins',
    restaurantTags: const [RestaurantTagModel(id: 'tag_3', name: 'Fast Food')],
    restaurantImages: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantVideos: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantLocations: const [
      RestaurantLocationModel(
          id: 'loc_3', latitude: 40.714776, longitude: -74.006974)
    ],
    restaurantPhoneNumbers: [
      RestaurantPhoneNumber(phoneNumber: '+1234567890', id: '12')
    ],
  ),
  RestaurantModel(
    id: '4',
    name: 'Café Delights',
    openingHour: '08:00',
    closingHour: '20:00',
    isOpen: true,
    averagePrice: 20.0,
    averageRating: 4.3,
    numberOfReviews: 80,
    popularityIndex: 4,
    userId: 'user_004',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    distance: '2 km',
    walkingTime: '25 mins',
    ridingTime: '6 mins',
    restaurantTags: const [RestaurantTagModel(id: 'tag_4', name: 'Café')],
    restaurantImages: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantVideos: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantLocations: const [
      RestaurantLocationModel(
          id: 'loc_4', latitude: 40.715776, longitude: -74.008974)
    ],
    restaurantPhoneNumbers: [
      RestaurantPhoneNumber(phoneNumber: '+1234567890', id: '12')
    ],
  ),
  RestaurantModel(
    id: '5',
    name: 'Sushi Spot',
    openingHour: '12:00',
    closingHour: '22:00',
    isOpen: false,
    averagePrice: 40.0,
    averageRating: 4.9,
    numberOfReviews: 220,
    popularityIndex: 5,
    userId: 'user_005',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    distance: '4 km',
    walkingTime: '50 mins',
    ridingTime: '15 mins',
    restaurantTags: const [
      RestaurantTagModel(id: 'tag_5', name: 'Japanese Cuisine')
    ],
    restaurantImages: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantVideos: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantLocations: const [
      RestaurantLocationModel(
          id: 'loc_5', latitude: 40.716776, longitude: -74.009974)
    ],
    restaurantPhoneNumbers: [
      RestaurantPhoneNumber(phoneNumber: '+1234567890', id: '12')
    ],
  ),
  RestaurantModel(
    id: '6',
    name: 'Italian Corner',
    openingHour: '10:00',
    closingHour: '23:00',
    isOpen: true,
    averagePrice: 35.0,
    averageRating: 4.7,
    numberOfReviews: 180,
    popularityIndex: 6,
    userId: 'user_006',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    distance: '2.5 km',
    walkingTime: '30 mins',
    ridingTime: '8 mins',
    restaurantTags: const [
      RestaurantTagModel(id: 'tag_6', name: 'Italian Cuisine')
    ],
    restaurantImages: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantVideos: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantLocations: const [
      RestaurantLocationModel(
          id: 'loc_6', latitude: 40.717776, longitude: -74.010974)
    ],
    restaurantPhoneNumbers: [
      RestaurantPhoneNumber(phoneNumber: '+1234567890', id: '12')
    ],
  ),
  RestaurantModel(
    id: '7',
    name: 'Vegan Paradise',
    openingHour: '09:00',
    closingHour: '21:00',
    isOpen: true,
    averagePrice: 30.0,
    averageRating: 4.6,
    numberOfReviews: 140,
    popularityIndex: 7,
    userId: 'user_007',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    distance: '1 km',
    walkingTime: '15 mins',
    ridingTime: '4 mins',
    restaurantTags: const [RestaurantTagModel(id: 'tag_7', name: 'Vegan')],
    restaurantImages: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantVideos: [
      RestaurantMedia(
          id: '11',
          url: 'https://example.com/caesar_salad.jpg',
          isLeading: false)
    ],
    restaurantLocations: const [
      RestaurantLocationModel(
          id: 'loc_7', latitude: 40.718776, longitude: -74.011974)
    ],
    restaurantPhoneNumbers: [
      RestaurantPhoneNumber(phoneNumber: '+1234567890', id: '12')
    ],
  ),
  RestaurantModel(
      id: '8',
      name: 'Taco Fiesta',
      openingHour: '11:00',
      closingHour: '22:00',
      isOpen: false,
      averagePrice: 10.0,
      averageRating: 3.8,
      numberOfReviews: 90,
      popularityIndex: 8,
      userId: 'user_008',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      distance: '3.5 km',
      walkingTime: '45 mins',
      ridingTime: '12 mins',
      restaurantTags: const [
        RestaurantTagModel(id: 'tag_8', name: 'Mexican Cuisine'),
      ]),
];

var restaurantsSortedByRating = sortByRating(dummyRestaurants);
var restaurantsSortedByPrice = sortByPrice(dummyRestaurants);
var restaurantsSortedByDistance = sortByDistance(dummyRestaurants);
var restaurantsSortedByPopularity = sortByPopularity(dummyRestaurants);
