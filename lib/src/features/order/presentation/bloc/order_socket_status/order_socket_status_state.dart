part of 'order_socket_status_bloc.dart';

abstract class OrderSocketStatusState extends Equatable {
  const OrderSocketStatusState();

  @override
  List<Object> get props => [];
}

// Socket Connection
class OrderSocketLoadingState extends OrderSocketStatusState {}

class OrderSocketConnectedState extends OrderSocketStatusState {}

class OrderSocketFailedState extends OrderSocketStatusState {
  final String errorMessage;
  const OrderSocketFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
