import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import '../../../discover_item/data/models/search_result.dart';

abstract class LiveSearchDataProvider {
  Future<List<RestaurantResult>> searchRestaurants(String query);

  Future<List<ItemModel>> searchItems(
    String query, {
    required double latitude,
    required double longitude,
  });

  Future<List<RestaurantModel>> getPopularRestaurants(
      {required int limit, required int page});
  Future<List<ItemModel>> getPopularItems(
      {required int limit, required int page});
}

class LiveSearchDataProviderImpl extends LiveSearchDataProvider {
  final Dio dio;
  LiveSearchDataProviderImpl({required this.dio});

  @override
  Future<List<RestaurantResult>> searchRestaurants(String query) async {
    final url = "$baseURL/restaurants/all/search?searchTerm=$query";
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final List<dynamic> results = response.data["data"];
      return results
          .map((result) => RestaurantResult.fromJson(result))
          .toList();
    } catch (error) {
      throw NetworkException();
    }
  }

  @override
  Future<List<ItemModel>> searchItems(
    String query, {
    required double latitude,
    required double longitude,
  }) async {
    final url =
        "$baseURL/items/?searchTerm=$query&latitude=$latitude&longitude=$longitude";
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final List<dynamic> results = response.data["data"];
      var uniqueItemNames = <String>{};
      var allItems =
          results.map((result) => ItemModel.fromJson(result)).toList();
      // return allItems;
      var uniqueItems = <ItemModel>[];

      for (var item in allItems) {
        if (!uniqueItemNames.contains(item.itemName)) {
          uniqueItems.add(item);
          uniqueItemNames.add(item.itemName);
        }
      }

      return uniqueItems;
    } catch (error) {
      throw NetworkException();
    }
  }

  @override
  Future<List<RestaurantModel>> getPopularRestaurants({
    required int limit,
    required int page,
  }) async {
    try {
      final response = await dio
          .get('$baseURL/restaurants?popularity=true&limit=$limit&page=$page');
      if (response.statusCode == 200) {
        final json = response.data['data'];
        return json
            .map<RestaurantModel>((item) => RestaurantModel.fromMap(item))
            .toList();
      } else {
        throw Exception('Failed to load top rated items');
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<ItemModel>> getPopularItems(
      {required int limit, required int page}) async {
    try {
      final response = await dio.get(
          '$baseURL/items?minRating=2&sortedBy=rating?limit=$limit&page=$page');
      if (response.statusCode == 200) {
        final json = response.data['data'];
        return json.map<ItemModel>((item) => ItemModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load top rated items');
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
