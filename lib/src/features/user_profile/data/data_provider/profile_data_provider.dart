import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class ProfileDataProvider {
  final Dio dio;

  ProfileDataProvider({required this.dio});

  Future<UserModel> getCurrentUser() async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      if (user == null) {
        throw Exception("user not logged in");
      }
      final response = await dio
          .get(
            "$baseURL/users/profile/",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user.token!}',
              },
            ),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        log("fetch successfull $response");
        final user = UserModel.fromJson(response.data);
        return user;
      } else {
        log(response.toString());
        throw NetworkException();
      }
    } catch (e) {
      log("error in profile");
      log(e.toString());
      throw ServerException();
    }
  }

  Future<UserModel> getUser(String userId) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      if (user == null) {
        throw Exception("user not logged in");
      }
      final response = await dio
          .get(
            "$baseURL/users/profile/$userId",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user.token!}',
              },
            ),
          )
          .timeout(const Duration(seconds: 30));

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

  Future<List<UserReviewModel>> getUserReviews({
    required String userId,
    int page = 1,
    int limit = 4,
  }) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final response = await dio
          .get(
            "$baseURL/users/$userId/reviews?page=$page&limit=$limit",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user!.token!}',
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
        var allReviews = [...itemReviews, ...restaurantReviews];
        allReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return allReviews.cast<UserReviewModel>();
      } else {
        throw NetworkException();
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  Future<List<UserFavoriteModel>> getUserFavorites(String userId) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final response = await dio.get(
        "$baseURL/favorites",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token!}',
          },
        ),
      );

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

  Future<File> fixExifRotation(String imagePath) async {
    final imageFile = File(imagePath);
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return imageFile;
    final fixed = img.bakeOrientation(image);
    final fixedBytes = Uint8List.fromList(img.encodeJpg(fixed));
    final fixedFile = await imageFile.writeAsBytes(fixedBytes);
    return fixedFile;
  }

  Future<UserModel> editProfile({
    required Map<String, dynamic> updatedFields,
    required UserModel user,
  }) async {
    try {
      var formData = FormData.fromMap(updatedFields);

      if (updatedFields.containsKey('image')) {
        var imagePath = updatedFields['image'];
        if (imagePath != null && imagePath.isNotEmpty) {
          // 🧠 Fix rotation before uploading
          final fixedFile = await fixExifRotation(imagePath);
          var file = await MultipartFile.fromFile(fixedFile.path);
          formData.files.add(MapEntry('file', file));
        }
        formData.fields.removeWhere((element) => element.key == 'image');
      }

      // 🧠 Ensure date_of_birth is always in 'yyyy-MM-dd' format
      if (updatedFields.containsKey('date_of_birth') &&
          updatedFields['date_of_birth'] != null) {
        try {
          final dob = updatedFields['date_of_birth'];
          updatedFields['date_of_birth'] = DateFormat('yyyy-MM-dd').format(
            dob is DateTime ? dob : DateTime.parse(dob.toString()),
          );
        } catch (e) {
          debugPrint(
              '⚠️ Invalid date_of_birth format: ${updatedFields['date_of_birth']}');
          updatedFields.remove('date_of_birth'); // remove invalid value
        }
      }

      //* get current User
      final auth = dpLocator<AuthenticationLocalSource>().getUserCredential();
      debugPrint('data AAAAAAAAAAAAAA⚠️ ${updatedFields.toString()}');
      var response = await dio.put(
        '$baseURL/users/${auth!.id}',
        options: Options(
          headers: {'Authorization': 'Bearer ${auth.token!}'},
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        var updatedUser = user.copyWith(
          userName: updatedFields['user_name'] ?? user.userName,
          firstName: updatedFields['first_name'] ?? user.firstName,
          lastName: updatedFields['last_name'] ?? user.lastName,
          email: updatedFields['email'] ?? user.email,
          gender: updatedFields['gender'] ?? user.gender,
          dateOfBirth: (() {
            final dob = updatedFields['date_of_birth'];
            if (dob == null) return user.dateOfBirth;
            try {
              return DateFormat('yyyy-MM-dd').format(
                dob is DateTime ? dob : DateTime.parse(dob.toString()),
              );
            } catch (_) {
              return user.dateOfBirth;
            }
          })(),
        );

        return updatedUser;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Server Error");
      }
    }
  }

  Future<List<SavedReviewsResponseModel>> getSavedReviews({
    required int page,
    required int limit,
  }) async {
    try {
      //* get current User
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      final response = await dio
          .get(
            "$baseURL/users/${user!.id}/draft-item-reviews?page=$page&limit=$limit",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user.token!}',
              },
            ),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final savedReviews = data
            .map<SavedReviewsResponseModel>(
                (review) => SavedReviewsResponseModel.fromJson(review))
            .toList();
        return savedReviews;
      } else {
        throw NetworkException();
      }
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

//Check user name
  Future<bool> checkUsernameAvailability({required String userName}) async {
    try {
      final response = await dio.get(
        '$baseURL/auth/search-username?username=$userName',
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode != 404) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "Something went wrong");
      }
    }
  }

  Future<List<UserRecommendation>> getUserRecommendations(int page) async {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    const int limit = 10;
    try {
      final response = await dio
          .get(
            "$baseURL/users/${user!.id}/social/recommendations?page=$page&limit=$limit",
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${user.token!}',
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
      throw ServerException();
    }
  }

  Future<List<FollowUserModel>> getCurrentUserFollowers(
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

  Future<List<FollowUserModel>> getCurrentUserFollowings(
      {required String id, required int page, required String query}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      const int limit = 10;
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

  Future<void> updateUserPreference(int? preferedWalkingDistance,
      int? preferedDrivingDistance, int? minNumberOfReviews) async {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (user == null) {
      throw ServerException(errorMessage: "User not logged in");
    }
    try {
      final res = await dio.post(
        "$baseURL/user-preferences",
        data: {
          'preferredWalkingDistance': preferedWalkingDistance,
          'preferredDrivingDistance': preferedDrivingDistance,
          'minNumberOfReviews': minNumberOfReviews
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.token!}',
          },
        ),
      );
      if (res.statusCode != 200) {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException(
          errorMessage: e.response?.data['message'] ?? "Server exception");
    } catch (e) {
      throw ServerException(errorMessage: "Server exception");
    }
  }

  Future<UserPreference> getUserPreference() async {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (user == null) {
      throw ServerException(errorMessage: "User not logged in");
    }
    try {
      final res = await dio.get(
        "$baseURL/user-preferences",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user.token!}',
          },
        ),
      );
      if (res.statusCode != 200) {
        throw ServerException();
      }
      return UserPreferenceModel.fromMap(res.data["data"]);
    } on DioException catch (e) {
      throw ServerException(
          errorMessage: e.response?.data['message'] ?? "Server exception");
    } catch (e) {
      throw ServerException(errorMessage: "Server exception");
    }
  }
}
