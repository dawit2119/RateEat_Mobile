part of 'order_count_bloc.dart';

class OrdersCountEvent extends Equatable {
  final String userId;

  const OrdersCountEvent({required this.userId});
  @override
  List<Object> get props => [];
}

class FetchOrdersCount extends OrdersCountEvent {
  final String status;

  const FetchOrdersCount({required super.userId, required this.status});

  @override
  List<Object> get props => [status];
}
