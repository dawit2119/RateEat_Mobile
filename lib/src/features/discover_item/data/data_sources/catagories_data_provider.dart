import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/error/error.dart';
import '../models/catagory_model.dart';

class CatagoriesDataProvider {
  final Dio dio;

  CatagoriesDataProvider({required this.dio});
  Future<List<Category>> getCatagories(restaurantId) async {
    try {
      final response = await dio.get(
          'https://rateeat-backend-ij7jnmwh2q-zf.a.run.app/api/v1/restaurants/$restaurantId/menu/categories');
      log(response.data.toString(), name: 'CatagoriesDataProvider');
      return (response.data['data'] as List)
          .map((e) => Category.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }
}
