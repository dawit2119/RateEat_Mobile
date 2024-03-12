import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/restaurant_menu_item.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/entities.dart';

abstract class RestaurantDetailDataSource {
  //* Get Restaurant Details
  Future<RestaurantModel> getRestaurantDetail(
      {required String restaurantId, double? longitude, double? latitude});
  //*  Get Restaurant Items
  Future<List<ItemModel>> getRestaurantItems(
      {required int limit, required int page, required restaurantId});
  //* Get Restaurant Popular Items
  Future<List<RestaurantMenuItem>> getPopularItems({required restaurantId});
  //* Get popular restaurant review requests
  Future<PopularRestaurantReviewsResponseModel> getPopularRestaurantReviews(
      {required String restaurantId});
}

class RestaurantDetailDataSourceImpl extends RestaurantDetailDataSource {
  final Dio dio;
  RestaurantDetailDataSourceImpl({required this.dio});
  @override
  Future<RestaurantModel> getRestaurantDetail(
      {required String restaurantId,
      double? longitude,
      double? latitude}) async {
    late final Response response;
    try {
      if (longitude != null && latitude != null) {
        response = await dio.get("$baseURL/restaurants/$restaurantId",
            queryParameters: {"latitude": latitude, "longitude": longitude});
      } else {
        response = await dio.get(
          "$baseURL/restaurants/$restaurantId",
        );
      }

      final RestaurantModel restaurant =
          RestaurantModel.fromMap(response.data['data']);
      return restaurant;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<ItemModel>> getRestaurantItems(
      {required int limit, required int page, required restaurantId}) async {
    try {
      final response = await dio.get(
          '$baseURL/restaurants/$restaurantId/items?limit=$limit&page=$page');
      if (response.statusCode == 200) {
        final json = response.data['data'];
        return json.map<ItemModel>((item) => ItemModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load top rated items');
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<RestaurantMenuItem>> getPopularItems(
      {required restaurantId}) async {
    try {
      final response = await dio
          .get('$baseURL/restaurants/$restaurantId/items?sortedBy=rate');
      if (response.statusCode == 200) {
        final json = response.data['data'];
        print("this data $json");
        return json
            .map<RestaurantMenuItem>(
              (item) => RestaurantMenuItemModel.fromJson(item),
            )
            .toList();
      } else {
        throw Exception('Failed to load popular items');
      }
    } catch (e) {
      print("this error part $e");
      throw ServerException();
    }
  }

  @override
  Future<PopularRestaurantReviewsResponseModel> getPopularRestaurantReviews(
      {required String restaurantId}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (user != null) {
        headers.addEntries([
          MapEntry('Authorization', 'Bearer ${user.token}'),
        ]);
      }

      final response = await dio.get(
        "$baseURL/restaurants/$restaurantId/reviews?sortedBy=popularity&limit=5",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final json = response.data['data'];
        final PopularRestaurantReviewsResponseModel restaurantReviews =
            PopularRestaurantReviewsResponseModel.fromJson(json);
        // restaurantReviews.reviews.sort(
        //   (
        //     restaurant1,
        //     restaurant2,
        //   ) =>
        //       restaurant2.createdAt!.compareTo(restaurant1.createdAt!),
        // );
        return restaurantReviews;
      } else {
        throw Exception("Invalid response");
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: e.toString());
      }
    }
  }
}
