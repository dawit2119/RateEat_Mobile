import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/datasource/remote_leaderboard_datasource.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/monthly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/weekly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/leader_board_repository.dart';

class LeaderRepoImpl implements LeaderRepository {
  final LeaderDataSource leaderDataSource;
  LeaderRepoImpl({required this.leaderDataSource});

  @override
  Future<Either<Failure, List<LeaderBoardModel>>> getLeaderBoard(
      {required int page, required int limit}) async {
    try {
      final res =
          await leaderDataSource.getLeaderBoard(limit: limit, page: page);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeeklyLeaderBoardResponses>> getWeeklyLeaderBoard(
      {required WeeklyLeaderBoardRequestModel
          weeklyLeaderBoardRequestModel}) async {
    try {
      final res = await leaderDataSource.getWeeklyLeaderBoard(
          weeklyLeaderBoardRequestModel: weeklyLeaderBoardRequestModel);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MonthlyLeaderBoardResponses>> getMonthlyLeaderBoard(
      {required MonthlyLeaderBoardRequestModel
          monthlyLeaderBoardRequestModel}) async {
    try {
      final res = await leaderDataSource.getMonthlyLeaderBoard(
          monthlyLeaderBoardRequestModel: monthlyLeaderBoardRequestModel);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
