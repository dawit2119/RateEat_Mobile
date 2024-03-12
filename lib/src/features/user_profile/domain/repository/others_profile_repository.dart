import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../domain.dart';

abstract class OthersProfileRepository {
  Future<Either<Failure, User>> getUser(String userId);
  Future<Either<Failure, List<UserReview>>> getUserReviews(
      String userId, int page);
  Future<Either<Failure, List<UserFavorite>>> getUserFavorites(String userId);
  Future<Either<Failure, List<UserRecommendation>>> getOtherUserRecommendations(
      {required String id, required int page});
  Future<Either<Failure, List<FollowUser>>> getFollowers(
      String userId, int page, String query);
  Future<Either<Failure, List<FollowUser>>> getFollowings(
      String userId, int page, String query);
}
