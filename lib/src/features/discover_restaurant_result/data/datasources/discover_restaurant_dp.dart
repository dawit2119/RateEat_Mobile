import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../models/discover_restaurant_result_model/discover_restaurant_result_model.dart';

class DiscoverRestaurantDataProvider {
  final Dio dio;

  DiscoverRestaurantDataProvider({
    required this.dio,
  });

  Future<List<DiscoverRestaurantResultModel>> getDiscoverRestaurantResults({
    required double latitude,
    required double longitude,
    required double radius,
    required double maxPrice,
    required double minRating,
    required int limit,
    required List<String> tags,
    required String sorting,
    required bool fasting,
    required int page,
    required int maxTravelTime,
    required TransportMode transportMode,
  }) async {
    try {
      if (sorting.isEmpty) {
        sorting = "rating";
      }
      String tagsQueryParam = '';
      if (tags.isNotEmpty) {
        tagsQueryParam = '&tags=${tags.join(',')}';
      }

      //* check Fasting
      String fastingQueryParam = '';
      if (fasting == true) {
        fastingQueryParam = '&fasting=$fasting';
      }
      var transportModeText = "";
      if (transportMode == TransportMode.walking) {
        transportModeText = "maxWalkingDistance";
      } else {
        transportModeText = "maxRidingDistance";
      }
      String url =
          '$baseURL/restaurants/discover/discoverRestaurants?$fastingQueryParam&sortedBy=$sorting&latitude=$latitude&longitude=$longitude&radius=$radius&maxPrice=$maxPrice&minRating=$minRating&limit=$limit&page=$page$tagsQueryParam&$transportModeText=$maxTravelTime';
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        final List<dynamic> restaurants = response.data['data'];
        return restaurants
            .map((restaurant) =>
                DiscoverRestaurantResultModel.fromJson(restaurant))
            .toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
