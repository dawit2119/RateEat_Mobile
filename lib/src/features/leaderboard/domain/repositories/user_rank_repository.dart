import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';

abstract class UserRankRepository {
  Future<Either<Failure, Rank>> getRank();
}
