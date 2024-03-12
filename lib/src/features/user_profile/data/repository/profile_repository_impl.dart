import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../data.dart';

class ProfileRepoImpl extends ProfileRepository {
  final ProfileDataProvider profileDataProvider;
  ProfileRepoImpl({required this.profileDataProvider});
  @override
  Future<Either<Failure, User>> editProfile({
    required User user,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      return Right(
        await profileDataProvider.editProfile(
          user: user as UserModel,
          updatedFields: updateData,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    try {
      final user = await profileDataProvider.getCurrentUser();
      await dpLocator<AuthenticationLocalSource>().updateUserCredential(
          updatedUserInformation: LocalUserModel(
        id: user.id,
        telegramId: user.telegramId,
        facebookId: user.facebookId,
        userName: user.userName,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        gender: user.gender,
        phoneNumber: user.phoneNumber,
        dateOfBirth: user.dateOfBirth,
        image: user.image,
        incentive: user.incentive,
        verified: user.verified,
      ));
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser(String userId) async {
    try {
      final user = await profileDataProvider.getUser(userId);
      await dpLocator<AuthenticationLocalSource>().updateUserCredential(
          updatedUserInformation: LocalUserModel(
        id: user.id,
        telegramId: user.telegramId,
        facebookId: user.facebookId,
        userName: user.userName,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        gender: user.gender,
        phoneNumber: user.phoneNumber,
        dateOfBirth: user.dateOfBirth,
        image: user.image,
        incentive: user.incentive,
        verified: user.verified,
      ));
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
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
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserReviewModel>>> getUserReviews({
    required String userId,
    int page = 1,
    int limit = 4,
  }) async {
    try {
      return Right(
        await profileDataProvider.getUserReviews(
          userId: userId,
          page: page,
          limit: limit,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavedReviewsResponseModel>>> getSavedReviews(
      {required int page, required int limit}) async {
    try {
      final response = await profileDataProvider.getSavedReviews(
        page: page,
        limit: limit,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUsernameAvailability(
      {required String userName}) async {
    try {
      final response = await profileDataProvider.checkUsernameAvailability(
        userName: userName,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserRecommendation>>> getUserRecommendations(
      int page) async {
    try {
      List<UserRecommendation> recommendations =
          await profileDataProvider.getUserRecommendations(page);
      return Right(recommendations);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FollowUser>>> getFollowers(
      String userId, int page, String query) async {
    try {
      List<FollowUser> users = await profileDataProvider
          .getCurrentUserFollowers(id: userId, page: page, query: query);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FollowUser>>> getFollowings(
      String userId, int page, String query) async {
    try {
      List<FollowUser> users = await profileDataProvider
          .getCurrentUserFollowings(id: userId, page: page, query: query);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserPreference(
    int? preferredWalkingDistance,
    int? preferredDrivingDistance,
    int? minNumberOfReviews,
  ) async {
    try {
      await profileDataProvider.updateUserPreference(
        preferredWalkingDistance,
        preferredDrivingDistance,
        minNumberOfReviews,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserPreference>> getUserPreference() async {
    try {
      final res = await profileDataProvider.getUserPreference();
      return Right(res);
    } on Exception catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
