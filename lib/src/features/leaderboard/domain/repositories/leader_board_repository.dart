import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/monthly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/weekly_leader_board_responses.dart';

abstract class LeaderRepository {
  Future<Either<Failure, List<LeaderBoardModel>>> getLeaderBoard(
      {required int page, required int limit});
  Future<Either<Failure, WeeklyLeaderBoardResponses>> getWeeklyLeaderBoard(
      {required WeeklyLeaderBoardRequestModel weeklyLeaderBoardRequestModel});
  Future<Either<Failure, MonthlyLeaderBoardResponses>> getMonthlyLeaderBoard(
      {required MonthlyLeaderBoardRequestModel monthlyLeaderBoardRequestModel});
}
