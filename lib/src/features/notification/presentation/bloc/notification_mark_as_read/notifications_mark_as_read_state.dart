part of 'notifications_mark_as_read_bloc.dart';

abstract class NotificationsMarkAsReadState extends Equatable {
  const NotificationsMarkAsReadState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationsMarkAsReadState {}

class MarkNotificationAsReadLoading extends NotificationsMarkAsReadState {}

class MarkNotificationAsReadFailed extends NotificationsMarkAsReadState {
  final String message;
  const MarkNotificationAsReadFailed({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class MarkNotificationAsReadSuccess extends NotificationsMarkAsReadState {
  final String message;
  const MarkNotificationAsReadSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
