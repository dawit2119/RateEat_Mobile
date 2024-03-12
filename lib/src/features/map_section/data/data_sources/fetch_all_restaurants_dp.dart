import 'package:dio/dio.dart';
import '../../../../core/core.dart';
import '../models/restaurant_model.dart';

class AllRestaurantsDataProvider {
  final Dio dio;

  AllRestaurantsDataProvider({required this.dio});

  Future<List<RestaurantModel>> fetchAllRestaurants({
    required int limit,
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    try {
      final response = await dio.get(
        '$baseURL/restaurants',
        queryParameters: {
          'limit': limit,
          'latitude': latitude,
          'longitude': longitude,
          'radius': radius,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data['data'];

        List<RestaurantModel> result = [];

        for (int i = 0; i < dataList.length; i++) {
          try {
            final item = dataList[i];
            result.add(RestaurantModel.fromMap(item));
          } catch (e, stackTrace) {
            // Rethrow so the UI knows something went wrong, or 'continue' to skip bad items
            throw NetworkException();
          }
        }

        return result;
      } else {
        throw NetworkException();
      }
    } on DioException catch (e) {
      throw NetworkException();
    } catch (e) {
      throw NetworkException();
    }
  }
}
