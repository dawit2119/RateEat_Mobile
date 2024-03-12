part of 'order_socket_status_bloc.dart';

abstract class OrderSocketStatusEvent extends Equatable {
  const OrderSocketStatusEvent();

  @override
  List<Object> get props => [];
}

// Socket Connection
class OrderConnectSocket extends OrderSocketStatusEvent {}

class OrderSocketFailed extends OrderSocketStatusEvent {
  final String errorMessage;

  const OrderSocketFailed({required this.errorMessage});
}

class OrderSocketConnected extends OrderSocketStatusEvent {
  const OrderSocketConnected();
}
