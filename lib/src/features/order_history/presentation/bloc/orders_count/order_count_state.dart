part of 'order_count_bloc.dart';

class OrdersCountState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrdersCountInitial extends OrdersCountState {}

class OrdersCountLoading extends OrdersCountState {}

class OrdersCountLoaded extends OrdersCountState {
  final int count;
  OrdersCountLoaded({required this.count});
}

class OrdersCountError extends OrdersCountState {
  final String message;
  OrdersCountError({required this.message});

  @override
  List<Object> get props => [message];
}
