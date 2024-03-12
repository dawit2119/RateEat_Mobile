import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_item_response_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_response_model.dart';

abstract class NearbyPlacesDataSource {
  //* Get Nearby Restaurant
  Future<List<NearByRestaurantResponseModel>> getNearByRestaurants(
      {required NearByRestaurantRequestModel nearByRestaurantRequestModel});
  //* Get Nearby Restaurant Items
  Future<List<NearByItemResponseModel>> getNearByRestaurantItems(
      {required NearByItemRequestModel nearByItemRequestModel});
  //* Save Review To Draft
  Future<String> addReviewToDraft(
      {required DraftReviewRequestModel draftReviewRequestModel});
}

class NearbyPlacesDataSourceImpl extends NearbyPlacesDataSource {
  final Dio dio;
  NearbyPlacesDataSourceImpl({required this.dio});

  @override
  Future<List<NearByRestaurantResponseModel>> getNearByRestaurants(
      {required NearByRestaurantRequestModel
          nearByRestaurantRequestModel}) async {
    try {
      final longitude = nearByRestaurantRequestModel.longitude.toString();
      final latitude = nearByRestaurantRequestModel.latitude.toString();
      final radius = nearByRestaurantRequestModel.radius.toString();
      final page = nearByRestaurantRequestModel.page.toString();
      final limit = nearByRestaurantRequestModel.limit.toString();
      final searchQuery = (nearByRestaurantRequestModel.searchQuery != null &&
              nearByRestaurantRequestModel.searchQuery != '')
          ? '&searchTerm=${nearByRestaurantRequestModel.searchQuery}'
          : '';

      final Response response;
      if (searchQuery != "") {
        response = await dio.get(
          '$baseURL/restaurants/all/search?$searchQuery',
        );
      } else {
        response = await dio.get(
          '$baseURL/restaurants?sortedBy=distance&latitude=$latitude&longitude=$longitude&radius=$radius&limit=$limit&page=$page$searchQuery',
        );
      }
      if (response.statusCode == 200) {
        final json = response.data['data'];
        final nearByRestaurants = json
            .map<NearByRestaurantResponseModel>((restaurant) =>
                NearByRestaurantResponseModel.fromMap(restaurant))
            .toList();
        return nearByRestaurants;
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
  Future<List<NearByItemResponseModel>> getNearByRestaurantItems(
      {required NearByItemRequestModel nearByItemRequestModel}) async {
    try {
      final restaurantId = nearByItemRequestModel.restaurantId;
      final page = nearByItemRequestModel.page.toString();
      final limit = nearByItemRequestModel.limit.toString();
      final itemName = (nearByItemRequestModel.itemName != '')
          ? '&searchTerm=${nearByItemRequestModel.itemName}'
          : '';

      String url =
          '$baseURL/restaurants/$restaurantId/items?page=$page&limit=$limit&sortedBy=rating$itemName';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final json = response.data['data'];
        final nearByItems = json
            .map<NearByItemResponseModel>(
                (item) => NearByItemResponseModel.fromMap(item))
            .toList();
        return nearByItems;
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
  Future<String> addReviewToDraft(
      {required DraftReviewRequestModel draftReviewRequestModel}) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final formData = FormData.fromMap({
        "restaurant_id": draftReviewRequestModel.restaurantId,
        "item_id": draftReviewRequestModel.itemId,
      });

      if (draftReviewRequestModel.images != null &&
          draftReviewRequestModel.images!.isNotEmpty) {
        final images = draftReviewRequestModel.images!;
        for (XFile image in images) {
          formData.files.addAll([
            MapEntry(
              "item_review_images",
              await MultipartFile.fromFile(image.path,
                  filename: image.path.split("/").last),
            )
          ]);
        }
      }
      if (draftReviewRequestModel.videos != null &&
          draftReviewRequestModel.videos!.isNotEmpty) {
        final videos = draftReviewRequestModel.videos!;
        for (XFile video in videos) {
          formData.files.addAll([
            MapEntry(
              "item_review_videos",
              await MultipartFile.fromFile(video.path,
                  filename: video.path.split("/").last),
            )
          ]);
        }
      }
      final response = await dio
          .post(
            "$baseURL/users/${user!.id}/draft-item-reviews",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user.token}'
              },
            ),
            data: formData,
          )
          .timeout(const Duration(seconds: 90));

      if (response.statusCode == 201) {
        return "Successfully Saved To Draft";
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
