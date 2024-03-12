import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';

class CandidateDataSource {
  final Dio dio;
  CandidateDataSource({required this.dio});
  Future<String> createCandidate(CandidRest candidRest) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final formData = FormData.fromMap({
        "name": candidRest.name,
        "relative_location": candidRest.description!,
      });

      if (candidRest.menuImages.isNotEmpty) {
        final images = candidRest.menuImages;
        for (File image in images) {
          formData.files.addAll([
            MapEntry(
              "menuImages",
              await MultipartFile.fromFile(image.path,
                  filename: image.path.split("/").last),
            )
          ]);
        }
      }
      if (candidRest.restImages != null && candidRest.restImages!.isNotEmpty) {
        final images = candidRest.restImages;
        for (File image in images!) {
          formData.files.addAll([
            MapEntry(
              "licenseImage",
              await MultipartFile.fromFile(image.path,
                  filename: image.path.split("/").last),
            )
          ]);
        }
      }
      final response = await dio.post(
        "$baseURL/candidate-restaurants",
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
        return "Restaurant registration is successful. We will review the suggested Restaurant";
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else if (e is ServerException) {
        throw ServerException(errorMessage: e.errorMessage);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }
}
