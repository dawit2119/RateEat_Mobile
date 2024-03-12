import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/user_rank_repository.dart';

class UserRankUseCase {
  final UserRankRepository userRankRepository;
  UserRankUseCase({required this.userRankRepository});

  Future<Either<Failure, Rank>> getRank() async {
    return await userRankRepository.getRank();
  }
}
