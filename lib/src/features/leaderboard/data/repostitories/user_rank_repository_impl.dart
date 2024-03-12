import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/datasource/remote_user_rank_datasource.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/user_rank_repository.dart';

class UserRankImpl implements UserRankRepository {
  final UserRankDataSource userRankDataSource;
  UserRankImpl({required this.userRankDataSource});
  @override
  Future<Either<Failure, Rank>> getRank() async {
    try {
      final res = await userRankDataSource.getRank();
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
