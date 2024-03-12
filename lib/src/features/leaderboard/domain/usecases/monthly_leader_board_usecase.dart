import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/monthly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/leader_board_repository.dart';

class GetMonthlyLeaderBoardUseCase
    extends UseCase<MonthlyLeaderBoardResponses, GetMonthlyLeaderBoardParams> {
  final LeaderRepository leaderRepository;
  GetMonthlyLeaderBoardUseCase({required this.leaderRepository});
  @override
  Future<Either<Failure, MonthlyLeaderBoardResponses>> call(
      GetMonthlyLeaderBoardParams params) async {
    return await leaderRepository.getMonthlyLeaderBoard(
      monthlyLeaderBoardRequestModel: params.monthlyLeaderBoardRequestModel,
    );
  }
}

class GetMonthlyLeaderBoardParams extends Equatable {
  final MonthlyLeaderBoardRequestModel monthlyLeaderBoardRequestModel;
  const GetMonthlyLeaderBoardParams(
      {required this.monthlyLeaderBoardRequestModel});

  @override
  List<Object?> get props => [];
}
