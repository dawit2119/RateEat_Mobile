import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../models/search_restaurant_model.dart';

class GetRestaurantDataProvider {
  final Dio dio;

  GetRestaurantDataProvider({required this.dio});

  Future<List<RestaurantSearchResultModel>> searchRestaurant(
      {required String query}) async {
    try {
      final response = await dio.get(
        '$baseURL/restaurants/all/search?searchTerm=$query',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map(
                (restaurant) => RestaurantSearchResultModel.fromMap(restaurant))
            .toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<RestaurantSearchResultModel>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        '$baseURL/restaurants?sortedBy=popularity&latitude=$latitude&longitude=$longitude&radius=2000',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map(
                (restaurant) => RestaurantSearchResultModel.fromMap(restaurant))
            .toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
