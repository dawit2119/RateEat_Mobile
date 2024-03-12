import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_responses_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_responses_model.dart';

class LeaderDataSource {
  final Dio dio;
  LeaderDataSource({required this.dio});

  Future<List<LeaderBoardModel>> getLeaderBoard({
    required int page,
    required int limit,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      final response = await dio.get(
        "$baseURL/users/incentives/all?page=$page&limit=$limit",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> res = response.data["data"];
        return res.map((user) => LeaderBoardModel.fromJson(user)).toList();
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<WeeklyLeaderBoardResponsesModel> getWeeklyLeaderBoard(
      {required WeeklyLeaderBoardRequestModel
          weeklyLeaderBoardRequestModel}) async {
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
        "$baseURL/users/incentives/all/weekly?page=${weeklyLeaderBoardRequestModel.page}&limit=${weeklyLeaderBoardRequestModel.limit}",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final res = response.data;
        return WeeklyLeaderBoardResponsesModel.fromJson(res);
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

  Future<MonthlyLeaderBoardResponsesModel> getMonthlyLeaderBoard(
      {required MonthlyLeaderBoardRequestModel
          monthlyLeaderBoardRequestModel}) async {
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
        "$baseURL/users/incentives/all/weekly?days=30&page=${monthlyLeaderBoardRequestModel.page}&limit=${monthlyLeaderBoardRequestModel.limit}",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        final res = response.data;
        return MonthlyLeaderBoardResponsesModel.fromJson(res);
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
