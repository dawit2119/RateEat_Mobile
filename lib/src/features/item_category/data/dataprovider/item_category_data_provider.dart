import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../features.dart';

class FoodCategoryDataProvider {
  final dio = dpLocator.get<Dio>();
  Future<List<ItemCategoryModel>> searchFoodCategory(
      String query, int page) async {
    // Perform search based on the query this is mock api. will be replaced
    try {
      final response = await dio.get(
        '$baseURL/items/item_tags?page=$page&searchTerm=$query',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final List<dynamic> itemCategories = response.data["data"];
      return itemCategories
          .map((itemCategory) => ItemCategoryModel.fromJson(itemCategory))
          .toList();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<ItemCategoryModel>> getTagSuggestion() async {
    try {
      final response = await dio.get(
        '$baseURL/items/item_tags?limit=20',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final List<dynamic> itemCategories = response.data["data"];
      return itemCategories
          .map((itemCategory) => ItemCategoryModel.fromJson(itemCategory))
          .toList();
    } catch (error) {
      throw NetworkException();
    }
  }
}
