import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';

import '../../presentation/bloc/items_filter_search_result/filter_item_result_params.dart';

abstract class SearchResultRemoteDataSource {
  //Restaurants
  Future<List<RestaurantModel>> getMostPopularRestaurants({
    required FilterRestaurantResultsParams filterResultParams,
    required int page,
    required int limit,
  });
  Future<List<RestaurantModel>> getClosestRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit});
  Future<List<RestaurantModel>> getHighestRatedRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit});
  Future<List<RestaurantModel>> getPriceSortedRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit});
  //Items
  Future<List<ItemModel>> getHighestRatedItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  });
  Future<List<ItemModel>> getClosestItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  });
  Future<List<ItemModel>> getPriceSortedItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  });
  Future<List<ItemModel>> getMostPopularItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  });
}

class SearchResultRemoteDataSourceImpl implements SearchResultRemoteDataSource {
  final Dio dio;

  SearchResultRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<RestaurantModel>> getClosestRestaurants({
    required FilterRestaurantResultsParams filterResultParams,
    required int page,
    required int limit,
  }) async {
    try {
      String url =
          '$baseURL/restaurants?latitude=${filterResultParams.location.latitude}&longitude=${filterResultParams.location.longitude}&radius=20000&page=$page&limit=$limit&sortedBy=distance&minRating=${filterResultParams.rating}&maxPrice=${filterResultParams.maximumPrice}';

      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final restaurants = response.data['data'];
        return restaurants
            .map<RestaurantModel>(
                (restaurant) => RestaurantModel.fromMap(restaurant))
            .toList();
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  @override
  Future<List<RestaurantModel>> getPriceSortedRestaurants(
      // Has no endpoint
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit}) async {
    try {
      String url =
          '$baseURL/restaurants?latitude=${filterResultParams.location.latitude}&longitude=${filterResultParams.location.longitude}&minRating=${filterResultParams.rating}&maxPrice=${filterResultParams.maximumPrice}&page=$page&limit=$limit&sortedBy=price';

      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final List<dynamic> restaurants = response.data['data'];
        return restaurants
            .map((restaurant) => RestaurantModel.fromMap(restaurant))
            .toList();
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  @override
  Future<List<RestaurantModel>> getHighestRatedRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit}) async {
    try {
      String url =
          '$baseURL/restaurants?latitude=${filterResultParams.location.latitude}&longitude=${filterResultParams.location.longitude}&minRating=${filterResultParams.rating}&maxPrice=${filterResultParams.maximumPrice}&page=$page&limit=$limit&sortedBy=rating';

      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final List<dynamic> restaurants = response.data['data'];
        return restaurants
            .map((restaurant) => RestaurantModel.fromMap(restaurant))
            .toList();
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  @override
  Future<List<RestaurantModel>> getMostPopularRestaurants(
      {required FilterRestaurantResultsParams filterResultParams,
      required int page,
      required int limit}) async {
    try {
      String url =
          '$baseURL/restaurants?latitude=${filterResultParams.location.latitude}&longitude=${filterResultParams.location.longitude}&minRating=${filterResultParams.rating}&maxPrice=${filterResultParams.maximumPrice}&page=$page&limit=$limit&sortedBy=popularity';

      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final List<dynamic> restaurants = response.data['data'];
        return restaurants
            .map((restaurant) => RestaurantModel.fromMap(restaurant))
            .toList();
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  @override
  Future<List<ItemModel>> getHighestRatedItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  }) async {
    try {
      String url =
          '$baseURL/items?latitude=$latitude&longitude=$longitude&sortedBy=rating&minRating=${filterResultParams.rating}&maxPrice=${filterResultParams.maximumPrice}&page=$page&limit=$limit';
      if (filterResultParams.searchQuery.isNotEmpty) {
        url += '&searchTerm=${filterResultParams.searchQuery}';
      } else if (filterResultParams.isFasting) {
        url += '&fasting=true';
      }
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['data'];
        return items.map((items) => ItemModel.fromJson(items)).toList();
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  @override
  Future<List<ItemModel>> getClosestItems(
      // Hs no endpoint
      {
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  }) async {
    try {
      String url =
          '$baseURL/items?latitude=$latitude&longitude=$longitude&sortedBy=distance&minRating=${filterResultParams.rating}&maxPrice=${filterResultParams.maximumPrice}&page=$page&limit=$limit';
      if (filterResultParams.searchQuery.isNotEmpty) {
        url += '&searchTerm=${filterResultParams.searchQuery}';
      } else if (filterResultParams.isFasting) {
        url += '&fasting=true';
      }
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['data'];
        return items.map((items) => ItemModel.fromJson(items)).toList();
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  @override
  Future<List<ItemModel>> getMostPopularItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  }) async {
    try {
      String url =
          '$baseURL/items?latitude=$latitude&longitude=$longitude&sortedBy=popularity&minRating=${filterResultParams.rating}&maxPrice=${filterResultParams.maximumPrice}&page=$page&limit=$limit';
      if (filterResultParams.searchQuery.isNotEmpty) {
        url += '&searchTerm=${filterResultParams.searchQuery}';
      }
      if (filterResultParams.isFasting) {
        url += '&fasting=true';
      }
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['data'];
        return items.map((items) => ItemModel.fromJson(items)).toList();
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  @override
  Future<List<ItemModel>> getPriceSortedItems({
    required FilterItemResultsParams filterResultParams,
    required int page,
    required int limit,
    required double latitude,
    required double longitude,
  }) async {
    try {
      String url =
          '$baseURL/items?latitude=$latitude&longitude=$longitude&sortedBy=price&minRating=${filterResultParams.rating}&maxPrice=${filterResultParams.maximumPrice}&page=$page&limit=$limit';
      if (filterResultParams.searchQuery.isNotEmpty) {
        url += '&searchTerm=${filterResultParams.searchQuery}';
      }
      if (filterResultParams.isFasting) {
        url += '&fasting=true';
      }
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['data'];
        return items.map((items) => ItemModel.fromJson(items)).toList();
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }
}
