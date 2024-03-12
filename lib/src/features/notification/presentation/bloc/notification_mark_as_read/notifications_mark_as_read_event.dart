part of 'notifications_mark_as_read_bloc.dart';

abstract class NotificationsMarkAsReadEvent extends Equatable {
  const NotificationsMarkAsReadEvent();

  @override
  List<Object?> get props => [];
}

class MarkNotificationStatusAsRead extends NotificationsMarkAsReadEvent {
  final String notificationId;
  const MarkNotificationStatusAsRead({
    required this.notificationId,
  });

  @override
  List<Object?> get props => [
        notificationId,
      ];
}
