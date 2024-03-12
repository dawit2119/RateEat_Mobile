import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import '../../../../core/core.dart';
import '../../domain/entities/notification.dart';
import '../models/notification.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getUserNotifications({
    required String userId,
    required int page,
    required int limit,
  });
  Future<NotificationEntity> markNotificationAsRead({
    required String notificationId,
  });
  Future<int> getUnreadNotificationsCount({
    required String userId,
  });
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final Dio dio;
  const NotificationsRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<NotificationModel>> getUserNotifications({
    required String userId,
    required int page,
    required int limit,
  }) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      if (user == null) {
        throw Exception("User not authenticated");
      }
      var url = "$baseURL/users/$userId/notifications?page=$page&limit=$limit";
      var response = await dio.get(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${user.token}',
            },
          ));
      if (response.statusCode == 200) {
        var notifications = response.data["data"]
            .map<NotificationModel>(
              (json) => NotificationModel.fromMap(json),
            )
            .toList();
        return notifications;
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<NotificationEntity> markNotificationAsRead(
      {required String notificationId}) async {
    try {
      var url = "$baseURL/notifications/$notificationId/mark-as-read";
      var response = await dio.put(url);
      if (response.statusCode == 200) {
        var updatedNotification = NotificationModel.fromMap(
          response.data['data'],
        );
        return updatedNotification;
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<int> getUnreadNotificationsCount({required String userId}) async {
    try {
      var url = "$baseURL/users/$userId/notifications?page=1&limit=1";
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data["unreadNotificationsCount"];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
