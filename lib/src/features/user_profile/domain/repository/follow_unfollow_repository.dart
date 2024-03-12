import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

abstract class FollowUnfollowRepository {
  Future<Either<Failure, bool>> followUser(String userId);
  Future<Either<Failure, bool>> unfollowUser(String userId);
}
