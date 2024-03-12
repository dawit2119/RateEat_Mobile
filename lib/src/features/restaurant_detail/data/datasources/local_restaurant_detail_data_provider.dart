import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu_item.dart';

import '../../domain/entities/popular_restaurant_reviews_response.dart';

abstract class RestaurantLocalDataSource {
  Future<void> cacheRestaurantDetail(RestaurantModel restaurant);
  Future<RestaurantModel?> getCachedRestaurantDetail(String restaurantId);
  Future<void> cacheRestaurantItems(String restaurantId, List<ItemModel> items);
  Future<List<ItemModel>> getCachedRestaurantItems(String restaurantId);
  Future<void> cachePopularItems(
      String restaurantId, List<RestaurantMenuItem> items);
  Future<List<RestaurantMenuItem>> getCachedPopularItems(String restaurantId);
  Future<void> cachePopularReviews(
      String restaurantId, PopularRestaurantReviewsResponse reviews);
  Future<PopularRestaurantReviewsResponse?> getCachedPopularReviews(
      String restaurantId);
}

class RestaurantLocalDataSourceImpl implements RestaurantLocalDataSource {
  late final Box<RestaurantModel> _restaurantDetailsBox;
  late final Box _restaurantItemsBox;
  late final Box<List<dynamic>> _popularItemsBox;
  late final Box _popularReviewsBox;

  RestaurantLocalDataSourceImpl({
    Box<RestaurantModel>? restaurantDetailsBox,
    Box? restaurantItemsBox,
    Box<List<dynamic>>? popularItemsBox,
    Box? popularReviewsBox,
  }) {
    _restaurantDetailsBox =
        restaurantDetailsBox ?? Hive.box<RestaurantModel>('restaurantDetails');
    _restaurantItemsBox =
        restaurantItemsBox ?? Hive.box<ItemModel>('restaurantItems');
    _popularItemsBox =
        popularItemsBox ?? Hive.box<List<dynamic>>('popularItems');
    _popularReviewsBox = popularReviewsBox ??
        Hive.box<PopularRestaurantReviewsResponse>('popularReviews');
  }

  @override
  Future<void> cacheRestaurantDetail(RestaurantModel restaurant) async {
    await _restaurantDetailsBox.put(restaurant.id, restaurant);
  }

  @override
  Future<RestaurantModel?> getCachedRestaurantDetail(
      String restaurantId) async {
    final restaurant = _restaurantDetailsBox.get(restaurantId);
    return restaurant;
  }

  @override
  Future<void> cacheRestaurantItems(
      String restaurantId, List<ItemModel> items) async {
    await _restaurantItemsBox.put(
      restaurantId,
      items.map((item) => item.toJson()).toList(),
    );
  }

  @override
  Future<List<ItemModel>> getCachedRestaurantItems(String restaurantId) async {
    final jsonList = _restaurantItemsBox.get(restaurantId) as List<dynamic>?;
    if (jsonList != null) {
      return jsonList.map((json) => ItemModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> cachePopularItems(
      String restaurantId, List<RestaurantMenuItem> items) async {
    await _popularItemsBox.put(
      restaurantId,
      items.map((item) => item.toJson()).toList(),
    );
  }

  @override
  Future<List<RestaurantMenuItem>> getCachedPopularItems(
      String restaurantId) async {
    final jsonList = _popularItemsBox.get(restaurantId);
    try {
      if (jsonList != null) {
        return jsonList
            .map((json) => Map<String, dynamic>.from(
                json as Map)) // Ensure correct type casting
            .map((json) => RestaurantMenuItem.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  @override
  Future<void> cachePopularReviews(
      String restaurantId, PopularRestaurantReviewsResponse reviews) async {
    await _popularReviewsBox.put(restaurantId, reviews);
  }

  @override
  Future<PopularRestaurantReviewsResponse?> getCachedPopularReviews(
      String restaurantId) async {
    final reviews = _popularReviewsBox.get(restaurantId)
        as PopularRestaurantReviewsResponse?;
    return reviews;
  }
}
