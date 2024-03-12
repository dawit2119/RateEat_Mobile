import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_reviews_response_model.dart';

abstract class ItemDataProvider {
  Future<ItemModel> getItem({required String itemId});
  Future<List<ItemModel>> getItemRecommendations({required String itemId});
  Future<PopularItemReviewsResponseModel> getPopularItemsReviews(
      {required String itemId});
}

class ItemDataProviderImpl extends ItemDataProvider {
  final Dio dio;
  ItemDataProviderImpl({required this.dio});

  @override
  Future<ItemModel> getItem({required String itemId}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      log("user in item detail $user");
      log(itemId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await dio.get(
        "$baseURL/items/$itemId",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        log("fetch successfull $response");
        final item = ItemModel.fromJson(response.data['data']);
        return item;
      } else {
        log("error in item detail");
        log(response.toString());
        throw ServerException(errorMessage: 'Failed to load item');
      }
    } catch (e) {
      log(e.toString());
      if (e is DioException) {
        log(e.response?.data['message'] ??
            "error from server while loading item detail");
        throw ServerException(
            errorMessage: e.response?.data['message'] ??
                "error from server while loading item detail");
      } else {
        throw ServerException(errorMessage: e.toString());
      }
    }
  }

  @override
  Future<List<ItemModel>> getItemRecommendations(
      {required String itemId}) async {
    try {
      final response = await dio.get("$baseURL/items/$itemId/recommendations");
      if (response.statusCode == 200) {
        List<ItemModel> itemRecommendations =
            (response.data['data']['recommendations'] as List)
                .map((recommendation) => ItemModel.fromJson(recommendation))
                .toList();
        return itemRecommendations;
      } else {
        throw ServerException(errorMessage: 'Failed to get recommendations');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: e.toString());
      }
    }
  }

  @override
  Future<PopularItemReviewsResponseModel> getPopularItemsReviews(
      {required String itemId}) async {
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
        "$baseURL/items/$itemId/reviews?sortedBy=popularity&limit=5",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final json = response.data['data'];
        final PopularItemReviewsResponseModel itemReviews =
            PopularItemReviewsResponseModel.fromJson(json);
        // itemReviews.reviews.sort(
        //   (r1, r2) =>
        //       r2.createdAt!.compareTo(r1.createdAt!), //Sorting descending order
        // );
        return itemReviews;
      } else {
        throw ServerException(errorMessage: 'Failed to get popular reviews');
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
