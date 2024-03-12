import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';

class UserRankDataSource {
  final Dio dio;
  UserRankDataSource({required this.dio});

  Future<Rank> getRank() async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final response = await dio.get(
        "$baseURL/users/${user!.id}/incentive",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final dynamic res = response.data["data"];

        return Rank.fromJson(res);
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
