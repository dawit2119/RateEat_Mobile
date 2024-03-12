import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import 'package:rateeat_mobile/src/features/homepage/data/data.dart';

class FilterItemsDataProvider {
  final Dio dio;
  FilterItemsDataProvider({required this.dio});
  Future<List<ItemModel>> getRestaurantItems({
    required String restaurantId,
    required String maxPrice,
    required bool fasting,
    required String sortingQuery,
    required String searchQuery,
    required int page,
    required int limit,
    String? categoryId,
  }) async {
    String searchTerm = '';
    if (searchQuery != '') {
      searchTerm = '&searchTerm=$searchQuery';
    }
    //* check Fasting
    String fastingQueryParam = '';
    if (fasting == true) {
      fastingQueryParam = '&fasting=$fasting';
    }
    String categoryIdParam = '';
    if (categoryId != '') {
      categoryIdParam = '&categoryId=$categoryId';
    }
    debugPrint(
        'check filter data provider : $baseURL/restaurants/$restaurantId/menu?$fastingQueryParam&page=$page&limit=$limit&maxPrice=$maxPrice&sortedBy=$sortingQuery$searchTerm$categoryIdParam');
    try {
      String url =
          '$baseURL/restaurants/$restaurantId/menu?$fastingQueryParam&page=$page&limit=$limit&maxPrice=$maxPrice&sortedBy=$sortingQuery$searchTerm$categoryIdParam';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      debugPrint('data source filter page $response');
      final List<dynamic> items = response.data["data"];
      return items.map((item) => ItemModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
