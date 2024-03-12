import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';
import '../../../../core/core.dart';
import '../domain.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getUser(String userId);
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, List<UserReview>>> getUserReviews({
    required String userId,
    int page = 1,
    int limit = 7,
  });
  Future<Either<Failure, List<SavedReviewsResponseModel>>> getSavedReviews(
      {required int page, required int limit});
  Future<Either<Failure, List<UserFavorite>>> getUserFavorites(String userId);
  Future<Either<Failure, User>> editProfile({
    required User user,
    required Map<String, dynamic> updateData,
  });
  Future<Either<Failure, bool>> checkUsernameAvailability(
      {required String userName});
  Future<Either<Failure, List<UserRecommendation>>> getUserRecommendations(
      int page);
  Future<Either<Failure, List<FollowUser>>> getFollowers(
      String userId, int page, String query);
  Future<Either<Failure, List<FollowUser>>> getFollowings(
      String userId, int page, String query);

  Future<Either<Failure, void>> updateUserPreference(
    int? preferredWalkingDistance,
    int? preferredDrivingDistance,
    int? minNumberOfReviews,
  );
  Future<Either<Failure, UserPreference>> getUserPreference();
}
