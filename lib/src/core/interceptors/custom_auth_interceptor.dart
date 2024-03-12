import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

class CustomAuthInterceptor extends Interceptor {
  DateTime? _lastRefreshTime;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    try {
      if (options.headers['Authorization'] != null && user != null) {
        final currToken = (options.headers['Authorization'] as String)
            .replaceFirst("Bearer ", "");
        final data = parseJwt(currToken);
        final expireDate =
            DateTime.fromMillisecondsSinceEpoch(data["exp"] * 1000);

        final now = DateTime.now();

        if (now.compareTo(expireDate) >= 0) {
          if (user.refreshtoken == null || user.refreshtoken!.isEmpty) {
            debugPrint(
                "Refresh token is empty string or null --> ${user.refreshtoken} <--");
            dpLocator<AuthenticationLocalSource>().clearUserCredential();
            return handler.reject(DioException(
              requestOptions: options,
              error: 'Refresh token expired',
            ));
          }

          if (_lastRefreshTime != null &&
              now.difference(_lastRefreshTime!).inSeconds < 5) {
            // If the last refresh was within 5 seconds, continue with the request
            return handler.next(options);
          }

          final refreshTokenData = parseJwt(user.refreshtoken!);
          final refreshTokenExpireDate = DateTime.fromMillisecondsSinceEpoch(
              refreshTokenData["exp"] * 1000);
          if (now.compareTo(refreshTokenExpireDate) >= 0) {
            dpLocator<AuthenticationLocalSource>().clearUserCredential();
            debugPrint("Refresh token expired");
            return handler.reject(DioException(
              requestOptions: options,
              error: 'Refresh token expired',
            ));
          } else {
            _lastRefreshTime = DateTime
                .now(); // Update the last refresh call time to prevent call limit exceeded
            final response = await dpLocator<AuthenticationRepository>()
                .refreshToken(refreshToken: user.refreshtoken!);
            response.fold((error) {
              handler.reject(DioException(
                requestOptions: options,
                error: 'Failed to refresh token ${error.errorMessage}',
              ));
            }, (data) {
              dpLocator<AuthenticationLocalSource>().updateUserCredential(
                  updatedUserInformation: LocalUserModel.fromUserModel(data));
              options.headers['Authorization'] = 'Bearer ${data.token}';
              handler.next(options); // Continue with the request
            });
            return; // Ensure handler is not called again
          }
        }
      }
    } catch (e) {
      debugPrint("error while refreshing token");
      debugPrint(e.toString());
      handler.reject(DioException(
        requestOptions: options,
        error: 'Unexpected error: $e',
      ));
      return;
    }
    handler.next(options); // Continue with the request if no refresh is needed
  }
}
