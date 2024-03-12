part of 'notification_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class GetUserNotifications extends NotificationsEvent {
  final String userId;
  final int page;
  const GetUserNotifications({
    required this.userId,
    this.page = 1,
  });

  @override
  List<Object?> get props => [
        userId,
        page,
      ];
}

class UpdateNotificationReadStatusLocally extends NotificationsEvent {
  final String key;
  final String notificationId;
  final Map<String, List<NotificationEntity>> notifications;

  const UpdateNotificationReadStatusLocally({
    required this.key,
    required this.notificationId,
    required this.notifications,
  });
}
