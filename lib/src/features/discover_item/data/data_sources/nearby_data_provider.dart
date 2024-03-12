import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/near_by_restaurants_response_model.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data.dart';

class NearByDataProvider {
  final Dio dio;
  NearByDataProvider({required this.dio});
  Future<NearbyRestaurantsResponseModel> getNearByRestaurants(
    double lat,
    double lng,
    List<String> tags,
    page,
    limit,
  ) async {
    try {
      var url =
          '$baseURL/restaurants/discover/discoverRestaurants?radius=10000&latitude=$lat&longitude=$lng&minRating=2&limit=$limit&page=$page&sortedBy=distance';
      if (tags.isNotEmpty) {
        url += '&tags=${tags.join(',')}';
      }

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
      final List<RestaurantModel> restaurants = results
          .map((restaurant) => RestaurantModel.fromMap(restaurant))
          .toList();
      final int totalItems = response.data["count"];
      return NearbyRestaurantsResponseModel(
          restaurants: restaurants, totalItems: totalItems);
    } catch (error) {
      throw NetworkException();
    }
  }
}
