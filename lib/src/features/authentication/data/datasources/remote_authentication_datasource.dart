import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/hive_init.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/authentication/data/models/user_login_response_model.dart';

import '../../../user_profile/data/data.dart';

abstract class RemoteAuthenticationSource {
  Future<UserModel> signUp({required UserModel user});

  Future<UserLoginResponseModel> loginFacebook({required String accessToken});
  Future<UserLoginResponseModel> loginGoogle(
      {required String email,
      required String accessToken,
      required String firstName,
      String? lastName});
  Future<UserLoginResponseModel> loginApple(
      {required String email,
      required String identityToken,
      required String firstName,
      String? lastName});
  Future<void> sendEmailOtp({required String email});
  Future<void> sendPhoneOtp({required String phoneNumber});
  Future<void> sendEditEmailOtp({required String email});
  Future<void> sendEditPhoneOtp({required String phoneNumber});
  Future<UserLoginResponseModel> verifyOtp(
      {required String phoneNumber, required String code});
  Future<UserLoginResponseModel> verifyEmailOtp(
      {required String email, required String code});
  Future<void> resendOtp({required String phoneNumber});
  Future<void> resendEmailOtp({required String email});
  Future<void> logout();
  Future<void> deleteAccount();
  Future<UserModel> getUser();
  Future<UserLoginResponseModel> refreshToken(String refreshtoken);
}

class RemoteAuthenticationSourceImpl extends RemoteAuthenticationSource {
  final Dio dio;
  final HiveService service;
  final AuthenticationLocalSource localSource;

  RemoteAuthenticationSourceImpl(
      {required this.dio, required this.service, required this.localSource});

  @override
  Future<UserModel> signUp({required UserModel user}) async {
    try {
      // Create FormData for the request
      var formData = FormData.fromMap({
        if (user.id != "") 'facebook_id': user.id,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'role_name': "user",
        'fcm_token': service.getFcmToken(),
        if (user.email != null) 'email': user.email,
        if (user.phoneNumber != null) 'phone_number': user.phoneNumber,
        if (user.dateOfBirth != null) 'birth_date': user.dateOfBirth,
        if (user.gender != null) 'gender': user.gender,
      });

      // Add image as a file if provided
      final check = user.image != null && user.image != '';
      if (check) {
        var file = await MultipartFile.fromFile(user.image!);
        formData.files.add(MapEntry('file', file));
      }
      // Send the request using Dio
      var response = await dio.post('$baseURL/auth/register', data: formData);
      // Handle the response
      if (response.statusCode == 200) {
        var res = response.data;
        return UserModel.fromJson(res);
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } on ServerException catch (e) {
        throw ServerException(errorMessage: e.errorMessage.toString());
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<UserModel> getUser() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPhoneOtp({required String phoneNumber}) async {
    final body = {
      'phone': phoneNumber,
      "fcm_token": service.getFcmToken(),
    };
    try {
      final response = await dio.post(
        '$baseURL/auth/send-otp',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } on ServerException catch (e) {
        throw ServerException(errorMessage: e.errorMessage.toString());
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<void> sendEmailOtp({required String email}) async {
    final body = {
      'email': email,
      'user': 'user',
      "fcm_token": service.getFcmToken(),
    };
    try {
      final response = await dio.post(
        '$baseURL/auth/send-email-otp',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } on ServerException catch (e) {
        throw ServerException(errorMessage: e.errorMessage.toString());
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<void> sendEditPhoneOtp({required String phoneNumber}) async {
    final body = {
      'phone': phoneNumber,
      "fcm_token": service.getFcmToken(),
    };
    try {
      final user = localSource.getUserCredential();

      final response = await dio.post(
        '$baseURL/auth/send-otp-to-user',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token!}',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } on ServerException catch (e) {
        throw ServerException(errorMessage: e.errorMessage.toString());
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<void> sendEditEmailOtp({required String email}) async {
    final body = {
      'gmail': email,
      "fcm_token": service.getFcmToken(),
    };
    try {
      final response = await dio.post(
        '$baseURL/auth/send-otp-to-user',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } on ServerException catch (e) {
        throw ServerException(errorMessage: e.errorMessage.toString());
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<UserLoginResponseModel> verifyOtp(
      {required String phoneNumber, required String code}) async {
    final body = {
      'phone': phoneNumber,
      'otp': code,
      'role_name': 'user',
      "fcm_token": service.getFcmToken(),
    };

    try {
      final response = await dio.post(
        '$baseURL/auth/register-phone',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      }
      if (response.statusCode == 201) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      } else if (response.statusCode == 400) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException();
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserLoginResponseModel> verifyEmailOtp(
      {required String email, required String code}) async {
    final body = {
      'email': email,
      'otp': code,
      'role_name': 'user',
      "fcm_token": service.getFcmToken(),
    };

    try {
      final response = await dio.post(
        '$baseURL/auth/register-email',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      }
      if (response.statusCode == 201) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      } else if (response.statusCode == 400) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException();
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> resendOtp({required String phoneNumber}) async {
    try {
      final body = {
        'phone': phoneNumber,
        "fcm_token": service.getFcmToken(),
      };

      final response = await dio.post(
        '$baseURL/auth/send-otp',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } on ServerException catch (e) {
        throw ServerException(errorMessage: e.errorMessage.toString());
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<void> resendEmailOtp({required String email}) async {
    try {
      final body = {
        'email': email,
        "fcm_token": service.getFcmToken(),
      };

      final response = await dio.post(
        '$baseURL/auth/send-email-otp',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: body,
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } on ServerException catch (e) {
        throw ServerException(errorMessage: e.errorMessage.toString());
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<UserLoginResponseModel> loginFacebook(
      {required String accessToken}) async {
    final body = {
      'access_token': accessToken,
      'fcm_token': service.getFcmToken(),
    };
    try {
      final response = await dio.post(
        '$baseURL/auth/login-facebook',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      }
      if (response.statusCode == 201) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      } else if (response.statusCode == 404) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException();
      }
    } on UnauthorizedRequestException {
      throw UnauthorizedRequestException();
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException(errorMessage: "Something Went Wrong");
    }
  }

  @override
  Future<UserLoginResponseModel> loginGoogle(
      {required String email,
      required String accessToken,
      required String firstName,
      String? lastName}) async {
    final body = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'access_token': accessToken,
      'role_name': 'user',
      "fcm_token": service.getFcmToken(),
    };
    print(body);
    try {
      final response = await dio.post(
        '$baseURL/auth/register-gmail',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      }
      if (response.statusCode == 201) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      } else if (response.statusCode == 404) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException();
      }
    } on UnauthorizedRequestException {
      throw UnauthorizedRequestException();
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException(errorMessage: "Server error");
      }
    } catch (e) {
      throw ServerException(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<UserLoginResponseModel> loginApple(
      {required String email,
      required String identityToken,
      required String firstName,
      String? lastName}) async {
    final body = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'identity_token': identityToken,
      'role_name': 'user',
      "fcm_token": service.getFcmToken(),
    };
    try {
      final response = await dio.post(
        '$baseURL/auth/login-apple',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      }
      if (response.statusCode == 201) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      } else if (response.statusCode == 404) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException();
      }
    } on UnauthorizedRequestException {
      throw UnauthorizedRequestException();
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw UnauthorizedRequestException();
      } else {
        throw ServerException(errorMessage: "Server error");
      }
    } catch (e) {
      throw ServerException(errorMessage: "Something went wrong");
    }
  }

  @override
  Future<void> logout() async {
    try {
      // 1. Capture the token FIRST
      final user = localSource.getUserCredential();
      final token = user?.token;

      // 2. Perform the API call using the captured token
      if (token != null && token.isNotEmpty) {
        try {
          await dio.get(
            '$baseURL/auth/logout',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token'
              }, // Use the variable, not user!.token
            ),
          );
        } catch (e) {
          // Even if API fails, we still want to log the user out locally
          print("API Logout failed: $e");
        }
      }

      // 3. Clear all local data AFTER the network attempt
      // (This ensures the UI still has data while the spinner is spinning)
      _safeClearProviders(); // Helper function for your provider clear calls
      await localSource.clearUserCredential();
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } on ServerException catch (e) {
        throw ServerException(errorMessage: e.errorMessage.toString());
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  void _safeClearProviders() {
    try {
      dpLocator<LocalProfileDataProvider>().removeProfileData();
    } catch (e) {}
    try {
      dpLocator<LocalProfileDataProvider>().removeSavedReviews();
    } catch (e) {}
    try {
      dpLocator<LocalProfileDataProvider>().removeUserRecommendations();
    } catch (e) {}
    try {
      dpLocator<LocalProfileDataProvider>().removeUserFavorites();
    } catch (e) {}
    try {
      dpLocator<LocalProfileDataProvider>().removeUserReviews();
    } catch (e) {}
  }

  @override
  Future<void> deleteAccount() async {
    try {
      //* get current User
      final user = localSource.getUserCredential();
      final response = await dio.delete(
        '$baseURL/auth/deactivate-account',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${user!.token!}',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(errorMessage: response.data['message']);
      }
    } catch (e) {
      try {
        if (e is DioException) {
          throw ServerException(errorMessage: e.response?.data['message']);
        } else {
          throw ServerException(errorMessage: "Something went wrong");
        }
      } on ServerException catch (e) {
        throw ServerException(errorMessage: e.errorMessage.toString());
      } catch (e) {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<UserLoginResponseModel> refreshToken(String refreshtoken) async {
    try {
      final body = {"refreshToken": refreshtoken};
      final response = await dio
          .post(
            '$baseURL/auth/refresh-token',
            data: body,
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final user = UserLoginResponseModel.fromJson(response);
        return user;
      } else {
        throw ServerException(errorMessage: response.toString());
      }
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
