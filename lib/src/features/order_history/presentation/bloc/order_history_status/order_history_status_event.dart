part of 'order_history_status_bloc.dart';

abstract class OrderHistoryStatusEvent extends Equatable {
  const OrderHistoryStatusEvent();

  @override
  List<Object> get props => [];
}

// Socket Connection
class OrderHistoryConnectSocket extends OrderHistoryStatusEvent {}

class OrderHistorySocketFailed extends OrderHistoryStatusEvent {
  final String errorMessage;

  const OrderHistorySocketFailed({required this.errorMessage});
}

class OrderHistorySocketConnected extends OrderHistoryStatusEvent {
  const OrderHistorySocketConnected();
}

class OrderHistoryStatusResetEvent extends OrderHistoryStatusEvent {
  const OrderHistoryStatusResetEvent();
}
