import 'dart:core';

import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/saved_reviews_response.dart';

abstract class LocalProfileDataProvider {
  Future<void> cacheProfileData(
    User user,
  );
  Future<void> removeProfileData();
  Future<User?> getProfileData();

  Future<void> cacheUserReviews(List<UserReview> userReviews);
  List<UserReview>? getUserReviews();
  Future<void> removeUserReviews();

  Future<void> cacheSavedReviews(List<SavedReviewsResponse> savedReviews);
  List<SavedReviewsResponse>? getSavedReviews();
  Future<void> removeSavedReviews();

  Future<void> cacheUserRecommendations(
      List<UserRecommendation> userRecommendations);
  List<UserRecommendation>? getUserRecommendations();
  Future<void> removeUserRecommendations();

  Future<void> cacheUserFavorites(List<UserFavorite> userFavorites);
  List<UserFavorite>? getUserFavorites();
  Future<void> removeUserFavorites();
}

class LocalProfileDataProviderImpl implements LocalProfileDataProvider {
  static const String userBox = "userProfileBox";
  static const String userKey = "userData";
  static const String userReviewsBox = "userReviewsBox";
  static const String savedReviewsBox = "savedReviewsBox";
  static const String userFavoriteBox = "userFavoritesBox";
  static const String userRecommendationsBox = "userRecommendationsBox";

  //* User Profile
  @override
  Future<void> cacheProfileData(User user) async {
    final box = Hive.box<User>(userBox);
    await box.put(userKey, user);
  }

  @override
  Future<void> removeProfileData() async {
    final box = Hive.box<User>(userBox);
    await box.delete(userKey);
  }

  @override
  Future<User?> getProfileData() async {
    final box = Hive.box<User>(userBox);
    final user = box.get(userKey);
    return user;
  }

  //* User Reviews
  @override
  Future<void> cacheUserReviews(userReviews) async {
    final box = Hive.box<UserReview>(userReviewsBox);
    await box.clear();
    await box.addAll(userReviews);
  }

  @override
  List<UserReview>? getUserReviews() {
    final box = Hive.box<UserReview>(userReviewsBox);
    final userReviews = box.values.toList();
    return userReviews;
  }

  @override
  Future<void> removeUserReviews() async {
    final box = Hive.box<UserReview>(userReviewsBox);
    await box.clear();
  }

  //* Saved Reviews
  @override
  Future<void> cacheSavedReviews(savedReviews) async {
    final box = Hive.box<SavedReviewsResponse>(savedReviewsBox);
    await box.clear();
    await box.addAll(savedReviews);
  }

  @override
  List<SavedReviewsResponse>? getSavedReviews() {
    final box = Hive.box<SavedReviewsResponse>(savedReviewsBox);
    final savedReviews = box.values.toList();
    return savedReviews;
  }

  @override
  Future<void> removeSavedReviews() async {
    final box = Hive.box<SavedReviewsResponse>(savedReviewsBox);
    await box.clear();
  }

  //* user recommendations
  @override
  Future<void> cacheUserRecommendations(userRecommendations) async {
    final box = Hive.box<UserRecommendation>(userRecommendationsBox);
    await box.clear();
    await box.addAll(userRecommendations);
  }

  @override
  List<UserRecommendation>? getUserRecommendations() {
    final box = Hive.box<UserRecommendation>(userRecommendationsBox);
    final userRecommendations = box.values.toList();
    return userRecommendations;
  }

  @override
  Future<void> removeUserRecommendations() async {
    final box = Hive.box<UserRecommendation>(userRecommendationsBox);
    await box.clear();
  }

  //* User Favorites
  @override
  Future<void> cacheUserFavorites(userFavorites) async {
    final box = Hive.box<UserFavorite>(userFavoriteBox);
    await box.clear();
    await box.addAll(userFavorites);
  }

  @override
  List<UserFavorite>? getUserFavorites() {
    final box = Hive.box<UserFavorite>(userFavoriteBox);
    final userFavorites = box.values.toList();
    return userFavorites;
  }

  @override
  Future<void> removeUserFavorites() async {
    final box = Hive.box<UserFavorite>(userFavoriteBox);
    await box.clear();
  }
}
