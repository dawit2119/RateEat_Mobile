import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/notification.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required String userId,
    required int page,
    required int limit,
  });
  Future<Either<Failure, NotificationEntity>> markNotificationAsRead(
      {required String notificationId});
  Future<Either<Failure, int>> getUnReadNotificationsCount({
    required String userId,
  });
}
