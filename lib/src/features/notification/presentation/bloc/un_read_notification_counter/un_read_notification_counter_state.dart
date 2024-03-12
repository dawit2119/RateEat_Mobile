part of 'un_read_notification_counter_bloc.dart';

abstract class UnreadNotificationsCounterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnreadNotificationsCounterLoading
    extends UnreadNotificationsCounterState {}

class UnreadNotificationsCounterFetchingFailed
    extends UnreadNotificationsCounterState {}

class UnreadNotificationsCounterFetched
    extends UnreadNotificationsCounterState {
  final int count;
  UnreadNotificationsCounterFetched({
    required this.count,
  });

  @override
  List<Object?> get props => [count];
}
