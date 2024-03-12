import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/leader_board_repository.dart';

class LeaderBoardUseCase {
  final LeaderRepository leaderRepository;
  LeaderBoardUseCase({required this.leaderRepository});
  Future<Either<Failure, List<LeaderBoardModel>>> getLeaders(
      {required int page, required int limit}) async {
    return await leaderRepository.getLeaderBoard(limit: limit, page: page);
  }
}
