part of 'order_history_status_bloc.dart';

abstract class OrderHistoryStatusState extends Equatable {
  const OrderHistoryStatusState();

  @override
  List<Object> get props => [];
}

// Socket Connection
class OrderHistorySocketLoadingState extends OrderHistoryStatusState {}

class OrderHistorySocketConnectedState extends OrderHistoryStatusState {}

class OrderHistorySocketFailedState extends OrderHistoryStatusState {
  final String errorMessage;
  const OrderHistorySocketFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
