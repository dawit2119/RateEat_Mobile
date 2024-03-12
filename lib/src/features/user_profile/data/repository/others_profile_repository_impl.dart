import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data_provider/other_profile_provider.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/repository/others_profile_repository.dart';

import '../../../../core/core.dart';
import '../data.dart';

class OthersProfileRepoImpl extends OthersProfileRepository {
  final OthersProfileDataProvider profileDataProvider;
  OthersProfileRepoImpl({required this.profileDataProvider});

  @override
  Future<Either<Failure, UserModel>> getUser(String userId) async {
    //TODO: Check for internet connectivity and other Failures
    try {
      return Right(
        await profileDataProvider.getUser(userId),
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Either<Failure, List<UserFavoriteModel>>> getUserFavorites(
      String userId) async {
    try {
      return Right(
        await profileDataProvider.getUserFavorites(userId),
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Either<Failure, List<UserReviewModel>>> getUserReviews(
      String userId, int page) async {
    try {
      return Right(
        await profileDataProvider.getUserReviews(userId, page),
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Either<Failure, List<UserRecommendation>>> getOtherUserRecommendations(
      {required String id, required int page}) async {
    try {
      List<UserRecommendation> recommendations = await profileDataProvider
          .getOtherUserRecommendations(id: id, page: page);
      return Right(recommendations);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FollowUser>>> getFollowers(
      String userId, int page, String query) async {
    try {
      List<FollowUser> users = await profileDataProvider.getOtherUserFollowers(
          id: userId, page: page, query: query);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FollowUser>>> getFollowings(
      String userId, int page, String query) async {
    try {
      List<FollowUser> users = await profileDataProvider.getOtherUserFollowings(
          id: userId, page: page, query: query);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
