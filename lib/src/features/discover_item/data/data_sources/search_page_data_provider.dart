import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';

class SearchPageDataProvider {
  final Dio dio;
  SearchPageDataProvider({required this.dio});
  Future<List<RestaurantResult>> searchRestaurants(String query) async {
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

      final List<dynamic> results = response.data["data"];
      return results
          .map((result) => RestaurantResult.fromJson(result))
          .toList();
    } catch (error) {
      if (error is DioException) {
        throw ServerException(errorMessage: error.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }
}
