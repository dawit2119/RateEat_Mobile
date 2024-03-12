part of 'notification_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsNextLoading extends NotificationsState {
  final Map<String, List<NotificationEntity>> notifications;
  const NotificationsNextLoading({
    required this.notifications,
  });
  @override
  List<Object> get props => [notifications];
}

class NotificationsLoaded extends NotificationsState {
  final Map<String, List<NotificationEntity>> notifications;
  final bool hasReachedMax;
  final bool fetchingStatus;
  const NotificationsLoaded({
    required this.notifications,
    this.hasReachedMax = false,
    this.fetchingStatus = true,
  });
  @override
  List<Object> get props => [
        notifications,
        hasReachedMax,
      ];
}

class NotificationActionsFailed extends NotificationsState {
  final String message;
  const NotificationActionsFailed({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class NotificationActionsSuccess extends NotificationsState {
  final String message;
  const NotificationActionsSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
