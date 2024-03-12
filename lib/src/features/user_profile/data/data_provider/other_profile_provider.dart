import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class OthersProfileDataProvider {
  final Dio dio;

  OthersProfileDataProvider({required this.dio});

  Future<UserModel> getUser(String userId) async {
    try {
      final currUser =
          dpLocator<AuthenticationLocalSource>().getUserCredential();
      Response response;
      if (currUser != null) {
        response = await dio
            .get(
              "$baseURL/users/profile/$userId",
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer ${currUser.token!}',
                },
              ),
            )
            .timeout(const Duration(seconds: 30));
      } else {
        response = await dio
            .get(
              "$baseURL/users/profile/$userId",
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            )
            .timeout(const Duration(seconds: 30));
      }

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        return user;
      } else {
        throw NetworkException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  Future<bool> followUser(String userId) async {
    try {
      final currUser =
          dpLocator<AuthenticationLocalSource>().getUserCredential();
      if (currUser == null) {
        throw UnauthorizedRequestException();
      }
      final response = await dio.post(
          "$baseURL/users/${currUser.id}/social/follow",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${currUser.token!}',
            },
          ),
          data: {
            "followedUserId": userId
          }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 201) {
        return true;
      } else {
        throw NetworkException();
      }
    } catch (e) {
      if (e is DioException) {
        throw NetworkException();
      } else {
        throw ServerException();
      }
    }
  }

  Future<bool> unFollowUser(String userId) async {
    try {
      final currUser =
          dpLocator<AuthenticationLocalSource>().getUserCredential();
      if (currUser == null) {
        throw UnauthorizedRequestException();
      }
      final response =
          await dio.delete("$baseURL/users/${currUser.id}/social/unfollow",
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer ${currUser.token!}',
                },
              ),
              data: {"followedUserId": userId});
      if (response.statusCode == 200) {
        return true;
      } else {
        throw NetworkException();
      }
    } catch (e) {
      if (e is DioException) {
        throw NetworkException();
      } else {
        throw ServerException();
      }
    }
  }

  Future<List<UserReviewModel>> getUserReviews(String userId, int page) async {
    try {
      final response = await dio
          .get(
            "$baseURL/users/$userId/reviews?page=$page&limit=10",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data['data'];
        var itemReviewsData = data['itemReviews'];
        var itemReviews = itemReviewsData
            .map((review) => UserReviewModel.fromMap(review, true))
            .toList();
        var restaurantReviewData = data['restaurantReviews'];
        var restaurantReviews = restaurantReviewData
            .map((review) => UserReviewModel.fromMap(review, false))
            .toList();

        return [...itemReviews, ...restaurantReviews];
      } else {
        throw NetworkException();
      }
    } catch (e) {
      if (e is DioException) {
        throw NetworkException();
      } else {
        throw ServerException();
      }
    }
  }

  Future<List<UserFavoriteModel>> getUserFavorites(String userId) async {
    try {
      final response = await dio
          .get(
            "$baseURL/users/$userId/favorites",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        var userFavorites =
            data.map((review) => UserFavoriteModel.fromMap(review)).toList();
        return userFavorites;
      } else {
        throw NetworkException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<UserRecommendation>> getOtherUserRecommendations(
      {required String id, required int page}) async {
    try {
      const int limit = 10;
      final response = await dio
          .get(
            "$baseURL/users/$id/social/recommendations?page=$page&limit=$limit",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        var userRecommendations = data
            .map((recommendation) =>
                UserRecommendationModel.fromMap(recommendation))
            .toList();
        return userRecommendations;
      } else {
        throw NetworkException();
      }
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  Future<List<FollowUserModel>> getOtherUserFollowers(
      {required String id, required int page, required String query}) async {
    try {
      const int limit = 10;
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final headers = user != null
          ? {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.token!}',
            }
          : {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            };
      final response = await dio
          .get(
            "$baseURL/users/$id/social/followers?page=$page&limit=$limit&searchTerm=$query",
            options: Options(
              headers: headers,
            ),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<FollowUserModel> users =
            data.map((user) => FollowUserModel.fromMap(user)).toList();
        return users;
      } else {
        throw NetworkException();
      }
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  Future<List<FollowUserModel>> getOtherUserFollowings(
      {required String id, required int page, required String query}) async {
    try {
      const int limit = 10;
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final headers = user != null
          ? {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${user.token!}',
            }
          : {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            };
      final response = await dio
          .get(
            "$baseURL/users/$id/social/following?page=$page&limit=$limit&searchTerm=$query",
            options: Options(
              headers: headers,
            ),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<FollowUserModel> users =
            data.map((user) => FollowUserModel.fromMap(user)).toList();
        return users;
      } else {
        throw NetworkException();
      }
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
