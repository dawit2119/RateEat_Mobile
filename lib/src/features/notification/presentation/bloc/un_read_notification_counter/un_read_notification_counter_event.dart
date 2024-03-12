part of 'un_read_notification_counter_bloc.dart';

abstract class UnreadNotificationsCounterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUnreadNotificationsCount extends UnreadNotificationsCounterEvent {
  final String userId;
  GetUnreadNotificationsCount({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}
