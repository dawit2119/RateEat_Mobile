import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../models/search_food_model.dart';

class GetFoodDataProvider {
  final Dio dio;

  GetFoodDataProvider({required this.dio});

  Future<List<FoodSearchResultModel>> searchFood(
      {required String restaurantId, required String query}) async {
    try {
      final response = await dio.get(
        '$baseURL/restaurants/$restaurantId/items?searchTerm=$query',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((food) => FoodSearchResultModel.fromMap(food))
            .toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<FoodSearchResultModel>> getHighestRatedFoods(
      {required String restaurantId}) async {
    try {
      final response = await dio.get(
        '$baseURL/restaurants/$restaurantId/items',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((food) => FoodSearchResultModel.fromMap(food))
            .toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
