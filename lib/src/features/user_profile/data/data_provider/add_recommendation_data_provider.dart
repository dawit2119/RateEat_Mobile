import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

class AddRecommendationDataProvider {
  final Dio dio;
  const AddRecommendationDataProvider({required this.dio});
  Future<void> addItemRecommendation(String itemId, String message) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      if (user == null) {
        throw Exception('user not authenticated');
      }
      final res = await dio.post(
        "$baseURL/users/${user.id}/social/recommend",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.token!}',
          },
        ),
        data: {"recommendedItemId": itemId, "message": message},
      ).timeout(const Duration(seconds: 30));
      if (res.statusCode != 201) {
        throw Exception("Server Error");
      }
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addRestaurantRecommendation(
      String restaurantId, String message) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      if (user == null) {
        throw Exception('user not authenticated');
      }
      final res = await dio.post(
        "$baseURL/users/${user.id}/social/recommend",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.token!}',
          },
        ),
        data: {"recommendedRestaurantId": restaurantId, "message": message},
      ).timeout(const Duration(seconds: 30));
      if (res.statusCode != 201) {
        throw Exception("Server Error");
      }
      return;
    } catch (e) {
      rethrow;
    }
  }
}
