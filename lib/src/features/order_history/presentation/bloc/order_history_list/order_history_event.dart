part of 'order_history_bloc.dart';

class OrderHistoryEvent extends Equatable {
  final String userId;
  final String status;

  const OrderHistoryEvent({
    required this.userId,
    required this.status,
  });
  @override
  List<Object> get props => [userId, status];
}

class FetchOrderHistory extends OrderHistoryEvent {
  final int page;
  final int limit;
  const FetchOrderHistory({
    required super.userId,
    required super.status,
    this.page = 1,
    required this.limit,
  });

  @override
  List<Object> get props => [userId, status];
}
