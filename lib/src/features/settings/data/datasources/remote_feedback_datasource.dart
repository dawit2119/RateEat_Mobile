import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

class FeedbackDataSource {
  final Dio dio;

  FeedbackDataSource({required this.dio});

  Future<String> giveFeedback(String comment) async {
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

      final response = await dio.post(
        "$baseURL/feedbacks",
        options: Options(
          headers: headers,
        ),
        data: {
          "text": comment,
        },
      );

      if (response.statusCode == 200) {
        return "Feedback submitted successfully";
      } else {
        throw ServerException();
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
