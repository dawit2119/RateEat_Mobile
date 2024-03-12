import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class AddRestaurantReviewDp {
  final Dio dio;

  AddRestaurantReviewDp({required this.dio});

  Future<void> addRestaurantReview({
    required String restaurantId,
    required String reviewMessage,
    required double rating,
    required List<File> reviewMedia,
  }) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final formData = FormData.fromMap({
        "rating": rating,
        "comment": reviewMessage.trim(),
      });

      Future<void> addMediaToFile(File file, String type) async {
        final fileExt = file.path.split('.').last;
        if (['jpg', 'jpeg', 'png'].contains(fileExt)) {
          type = "restaurant_review_images";
        } else if (['mp4', 'mov'].contains(fileExt)) {
          type = "restaurant_review_videos";
        }
        formData.files.add(
          MapEntry(
            type,
            await MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last),
          ),
        );
      }

      for (var file in reviewMedia) {
        addMediaToFile(file, "unknown_type");
      }

      final response = await dio.post(
        '$baseURL/restaurants/$restaurantId/reviews',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user!.token}'
        }),
        data: formData,
      );
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
