import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_response_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_response_model.dart';

List<NearByItemResponseModel> dummyNearByItems = [
  const NearByItemResponseModel(
    id: "1",
    name: "Classic American Burger",
    imageUri: "path/to/burger_image.jpg",
  ),
  const NearByItemResponseModel(
    id: "2",
    name: "Vegetarian Pizza",
    imageUri: "path/to/pizza_image.jpg",
  ),
  const NearByItemResponseModel(
    id: "3",
    name: "Sushi Platter",
    imageUri: "path/to/sushi_image.jpg",
  ),
  const NearByItemResponseModel(
    id: "4",
    name: "Chicken Caesar Salad",
    imageUri: "path/to/salad_image.jpg",
  ),
  const NearByItemResponseModel(
    id: "5",
    name: "Chicken Shewarma",
    imageUri: "path/to/shewarma_image.jpg",
  ),
];

List<NearByRestaurantResponseModel> dummyNearbyRestaurants = [
  const NearByRestaurantResponseModel(
      id: "r1", name: "The Green Terrace", currency: "ETB"),
  const NearByRestaurantResponseModel(
      id: "r2", name: "Seafood Delight", currency: "ETB"),
  const NearByRestaurantResponseModel(
      id: "r3", name: "Italian Pasta House", currency: "ETB"),
  const NearByRestaurantResponseModel(
      id: "r4", name: "BBQ Nation", currency: "ETB"),
  const NearByRestaurantResponseModel(
      id: "r5", name: "Sushi Corner", currency: "ETB")
];
