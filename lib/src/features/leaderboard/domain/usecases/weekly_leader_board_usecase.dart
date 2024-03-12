import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/weekly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/leader_board_repository.dart';

class GetWeeklyLeaderBoardUseCase
    extends UseCase<WeeklyLeaderBoardResponses, GetWeeklyLeaderBoardParams> {
  final LeaderRepository leaderRepository;
  GetWeeklyLeaderBoardUseCase({required this.leaderRepository});
  @override
  Future<Either<Failure, WeeklyLeaderBoardResponses>> call(
      GetWeeklyLeaderBoardParams params) async {
    return await leaderRepository.getWeeklyLeaderBoard(
      weeklyLeaderBoardRequestModel: params.weeklyLeaderBoardRequestModel,
    );
  }
}

class GetWeeklyLeaderBoardParams extends Equatable {
  final WeeklyLeaderBoardRequestModel weeklyLeaderBoardRequestModel;
  const GetWeeklyLeaderBoardParams(
      {required this.weeklyLeaderBoardRequestModel});

  @override
  List<Object?> get props => [];
}
