part of 'order_history_bloc.dart';

class OrderHistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryNextLoading extends OrderHistoryState {
  final List<OrderHistory> orders;
  final int page;
  OrderHistoryNextLoading({
    required this.orders,
    required this.page,
  });
}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<OrderHistory> orders;
  final bool hasReachedMax;

  final int page;
  OrderHistoryLoaded({
    required this.orders,
    this.page = 1,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [orders];
}

class OrderHistoryError extends OrderHistoryState {
  final String errorMessage;
  OrderHistoryError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
