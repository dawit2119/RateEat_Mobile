import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/restaurant_reviews_response_model.dart';

abstract class RestaurantReviewDataSource {
  //* Add Restaurant Review
  Future<String> addRestaurantReview(
      {required AddRestaurantReviewRequestModel
          addRestaurantReviewRequestModel});
  //* Edit Restaurant Review
  Future<String> editRestaurantReview(
      {required EditRestaurantReviewRequestModel
          editRestaurantReviewRequestModel});
  //* Delete Restaurant Review
  Future<String> deleteRestaurantReview(
      {required DeleteRestaurantReviewRequestModel
          deleteRestaurantReviewRequestModel});
  //* Get All Restaurant Reviews By Time
  Future<RestaurantReviewsResponseModel> getAllRestaurantReviewsByTime(
      {required String restaurantId, required int limit, required int page});
  //* Get All Restaurant Reviews By Popularity
  Future<RestaurantReviewsResponseModel> getAllRestaurantReviewsByPopularity(
      {required String restaurantId, required int limit, required int page});
}

class RestaurantReviewDataSourceImpl extends RestaurantReviewDataSource {
  final Dio dio;
  RestaurantReviewDataSourceImpl({required this.dio});

  @override
  Future<String> addRestaurantReview(
      {required AddRestaurantReviewRequestModel
          addRestaurantReviewRequestModel}) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      //* form data
      final formData = FormData.fromMap({
        "rating": addRestaurantReviewRequestModel.rating,
        "comment": addRestaurantReviewRequestModel.comment!.trim(),
      });
      if (addRestaurantReviewRequestModel.images != null &&
          addRestaurantReviewRequestModel.images!.isNotEmpty) {
        final images = addRestaurantReviewRequestModel.images!;
        for (File item in images) {
          formData.files.addAll([
            MapEntry(
              "restaurant_review_images",
              await MultipartFile.fromFile(
                item.path,
                filename: item.path.split("/").last,
              ),
            )
          ]);
        }
      }
      if (addRestaurantReviewRequestModel.videos != null &&
          addRestaurantReviewRequestModel.videos!.isNotEmpty) {
        final videos = addRestaurantReviewRequestModel.videos!;
        for (File item in videos) {
          formData.files.addAll([
            MapEntry(
              "restaurant_review_videos",
              await MultipartFile.fromFile(
                item.path,
                filename: item.path.split("/").last,
              ),
            )
          ]);
        }
      }

      final response = await dio.post(
        "$baseURL/restaurants/${addRestaurantReviewRequestModel.restaurantId}/reviews",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token}'
          },
        ),
        data: formData,
      );

      if (response.statusCode == 201) {
        return response.data["message"];
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }

  @override
  Future<String> editRestaurantReview(
      {required EditRestaurantReviewRequestModel
          editRestaurantReviewRequestModel}) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      //* form data
      final formData = FormData();

      if (editRestaurantReviewRequestModel.rating != null) {
        final formattedRating = editRestaurantReviewRequestModel.rating;
        formData.fields.add(MapEntry("rating", formattedRating.toString()));
      }

      if (editRestaurantReviewRequestModel.comment != null) {
        formData.fields.add(MapEntry(
            "comment", editRestaurantReviewRequestModel.comment!.trim()));
      }

      if (editRestaurantReviewRequestModel.images != null &&
          editRestaurantReviewRequestModel.images!.isNotEmpty) {
        final images = editRestaurantReviewRequestModel.images!;
        for (File item in images) {
          formData.files.add(MapEntry(
            "restaurant_review_images",
            await MultipartFile.fromFile(
              item.path,
              filename: item.path.split("/").last,
            ),
          ));
        }
      }

      if (editRestaurantReviewRequestModel.videos != null &&
          editRestaurantReviewRequestModel.videos!.isNotEmpty) {
        final videos = editRestaurantReviewRequestModel.videos!;

        for (File item in videos) {
          formData.files.add(MapEntry(
            "restaurant_review_videos",
            await MultipartFile.fromFile(
              item.path,
              filename: item.path.split("/").last,
            ),
          ));
        }
      }
      final response = await dio.put(
        "$baseURL/restaurants/${editRestaurantReviewRequestModel.restaurantId}/reviews/${editRestaurantReviewRequestModel.reviewId}",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token}'
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data["message"];
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }

  @override
  Future<String> deleteRestaurantReview(
      {required DeleteRestaurantReviewRequestModel
          deleteRestaurantReviewRequestModel}) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final response = await dio.delete(
        "$baseURL/restaurants/${deleteRestaurantReviewRequestModel.restaurantId}/reviews/${deleteRestaurantReviewRequestModel.reviewId}",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token}'
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data["message"];
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }

  @override
  Future<RestaurantReviewsResponseModel> getAllRestaurantReviewsByTime(
      {required String restaurantId,
      required int limit,
      required int page}) async {
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
        "$baseURL/restaurants/$restaurantId/reviews?sortedBy=time&page=$page&limit=$limit",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final json = response.data['data'];
        final RestaurantReviewsResponseModel restaurantReviews =
            RestaurantReviewsResponseModel.fromJson(json);

        return restaurantReviews;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }

  @override
  Future<RestaurantReviewsResponseModel> getAllRestaurantReviewsByPopularity(
      {required String restaurantId,
      required int limit,
      required int page}) async {
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
        "$baseURL/restaurants/$restaurantId/reviews?sortedBy=popularity&page=$page&limit=$limit",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final json = response.data['data'];
        final RestaurantReviewsResponseModel restaurantReviews =
            RestaurantReviewsResponseModel.fromJson(json);
        return restaurantReviews;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }
}
