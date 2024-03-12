import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data_provider/other_profile_provider.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/repository/follow_unfollow_repository.dart';

class FollowUnfollowRepositoryImpl extends FollowUnfollowRepository {
  final OthersProfileDataProvider othersProfileDataProvider;

  FollowUnfollowRepositoryImpl({required this.othersProfileDataProvider});

  @override
  Future<Either<Failure, bool>> followUser(String userId) async {
    try {
      return Right(await othersProfileDataProvider.followUser(userId));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, bool>> unfollowUser(String userId) async {
    try {
      return Right(await othersProfileDataProvider.unFollowUser(userId));
    } catch (e) {
      rethrow;
    }
  }
}
