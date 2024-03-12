import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/item_reviews_response_model.dart';

import '../../domain/entities/flag_review.dart';

abstract class ItemReviewDataSource {
  //* Add Item Review
  Future<bool> addItemReview({
    required AddItemReviewRequestModel addItemReviewRequestModel,
    required bool isCandidateItem,
  });
  //* Edit Item Review
  Future<String> editItemReview(
      {required EditItemReviewRequestModel editItemReviewRequestModel});
  //* Delete Item Review
  Future<String> deleteItemReview(
      {required DeleteItemReviewRequestModel deleteItemReviewRequestModel});
  //* Get All Item Review Requests By Time
  Future<ItemReviewsResponseModel> getItemReviewsByPopularity(
      {required String itemId, required int limit, required int page});
  //* Get All Item Review Requests By Popularity
  Future<ItemReviewsResponseModel> getItemReviewsByTime(
      {required String itemId, required int limit, required int page});
  //* Add Draft To Review
  Future<String> addDraftToReview(
      {required DraftToReviewRequestModel draftToReviewRequestModel});
  //* Delete Draft Review
  Future<String> deleteDraftItemReview(
      {required DeleteDraftItemReviewRequestModel
          deleteDraftItemReviewRequestModel});
  //* Flag reviews
  Future<String> flagReview({required FlagReview review});
}

class ItemReviewDataSourceImpl extends ItemReviewDataSource {
  final Dio dio;
  ItemReviewDataSourceImpl({required this.dio});

  @override
  Future<bool> addItemReview({
    required AddItemReviewRequestModel addItemReviewRequestModel,
    required bool isCandidateItem,
    bool? menuId,
  }) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final formData = FormData.fromMap({
        "rating": addItemReviewRequestModel.rating,
        "comment": addItemReviewRequestModel.comment!.trim(),
      });

      if (isCandidateItem) {
        formData.fields.add(
          MapEntry(
            "candidate_item_id",
            addItemReviewRequestModel.itemId,
          ),
        );
      }

      if (addItemReviewRequestModel.images != null &&
          addItemReviewRequestModel.images!.isNotEmpty) {
        final images = addItemReviewRequestModel.images!;
        for (File image in images) {
          formData.files.addAll([
            MapEntry(
              "item_review_images",
              await MultipartFile.fromFile(image.path,
                  filename: image.path.split("/").last),
            ),
          ]);
        }
      }
      if (addItemReviewRequestModel.videos != null &&
          addItemReviewRequestModel.videos!.isNotEmpty) {
        final videos = addItemReviewRequestModel.videos!;
        for (File video in videos) {
          formData.files.addAll([
            MapEntry(
              "item_review_videos",
              await MultipartFile.fromFile(video.path,
                  filename: video.path.split("/").last),
            )
          ]);
        }
      }
      final url = !isCandidateItem
          ? "$baseURL/items/${addItemReviewRequestModel.itemId}/reviews"
          : "$baseURL/candidate-item-reviews";
      final response = await dio.post(
        url,
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
        return true;
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
  Future<String> editItemReview(
      {required EditItemReviewRequestModel editItemReviewRequestModel}) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      //* form data
      final formData = FormData();

      if (editItemReviewRequestModel.rating != null) {
        final formattedRating = editItemReviewRequestModel.rating;
        formData.fields.add(MapEntry("rating", formattedRating.toString()));
      }

      if (editItemReviewRequestModel.comment != null) {
        formData.fields.add(
            MapEntry("comment", editItemReviewRequestModel.comment!.trim()));
      }

      if (editItemReviewRequestModel.images != null &&
          editItemReviewRequestModel.images!.isNotEmpty) {
        final images = editItemReviewRequestModel.images!;
        for (File image in images) {
          formData.files.add(MapEntry(
            "item_review_images",
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split("/").last,
            ),
          ));
        }
      }

      if (editItemReviewRequestModel.videos != null &&
          editItemReviewRequestModel.videos!.isNotEmpty) {
        final videos = editItemReviewRequestModel.videos!;
        for (File video in videos) {
          formData.files.add(MapEntry(
            "item_review_videos",
            await MultipartFile.fromFile(
              video.path,
              filename: video.path.split("/").last,
            ),
          ));
        }
      }
      final response = await dio.put(
        "$baseURL/items/${editItemReviewRequestModel.itemId}/reviews/${editItemReviewRequestModel.reviewId}",
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
  Future<String> deleteItemReview(
      {required DeleteItemReviewRequestModel
          deleteItemReviewRequestModel}) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final response = await dio.delete(
        "$baseURL/items/${deleteItemReviewRequestModel.itemId}/reviews/${deleteItemReviewRequestModel.reviewId}",
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
        throw ServerException(errorMessage: e.toString());
      }
    }
  }

  @override
  Future<ItemReviewsResponseModel> getItemReviewsByPopularity(
      {required String itemId, required int limit, required int page}) async {
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
        "$baseURL/items/$itemId/reviews?sortedBy=popularity&page=$page&limit=$limit",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final json = response.data['data'];
        final ItemReviewsResponseModel itemReviews =
            ItemReviewsResponseModel.fromJson(json);

        return itemReviews;
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
  Future<ItemReviewsResponseModel> getItemReviewsByTime(
      {required String itemId, required int limit, required int page}) async {
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
        "$baseURL/items/$itemId/reviews?sortedBy=time&page=$page&limit=$limit",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final json = response.data['data'];
        final ItemReviewsResponseModel itemReviews =
            ItemReviewsResponseModel.fromJson(json);

        return itemReviews;
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
  Future<String> flagReview({required FlagReview review}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final response = await dio
          .post(
            "$baseURL/reports",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user!.token}'
              },
            ),
            data: review.toJson(),
          )
          .timeout(
            const Duration(
              seconds: 30,
            ),
          );
      if (response.statusCode == 201) {
        return "review accepted";
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      throw ServerException(
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<String> addDraftToReview(
      {required DraftToReviewRequestModel draftToReviewRequestModel}) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final formData = FormData.fromMap({
        "rating": draftToReviewRequestModel.rating,
        "comment": draftToReviewRequestModel.comment!.trim(),
        "draft_item_review_id": draftToReviewRequestModel.draftItemReviewId,
      });

      final response = await dio.post(
        "$baseURL/items/${draftToReviewRequestModel.itemId}/reviews",
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
        return response.data['message'];
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
  Future<String> deleteDraftItemReview(
      {required DeleteDraftItemReviewRequestModel
          deleteDraftItemReviewRequestModel}) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final response = await dio.delete(
        "$baseURL/users/${user!.id}/draft-item-reviews/${deleteDraftItemReviewRequestModel.draftItemReviewId}",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.token}'
          },
        ),
      );

      if (response.statusCode == 200) {
        return "Successfully Deleted";
      } else {
        throw ServerException(errorMessage: response.data['message']);
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
