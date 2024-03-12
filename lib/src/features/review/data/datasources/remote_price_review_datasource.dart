import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';

abstract class PriceReviewDataSource {
  Future<String> priceReviewRequest(
      {required PriceReviewRequestModel priceReviewRequestModel});
}

class PriceReviewDataSourceImpl extends PriceReviewDataSource {
  final Dio dio;
  PriceReviewDataSourceImpl({required this.dio});

  @override
  Future<String> priceReviewRequest(
      {required PriceReviewRequestModel priceReviewRequestModel}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final formData =
          FormData.fromMap({"comment": priceReviewRequestModel.description!});
      if (priceReviewRequestModel.images.isNotEmpty) {
        final images = priceReviewRequestModel.images;
        for (File image in images) {
          formData.files.addAll([
            MapEntry(
              "updatedMenuImages",
              await MultipartFile.fromFile(image.path,
                  filename: image.path.split("/").last),
            )
          ]);
        }
      }

      final response = await dio.post(
        "$baseURL/restaurants/${priceReviewRequestModel.restaurantId}/updateMenu",
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
        return "Suggestion submitted successfully";
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
