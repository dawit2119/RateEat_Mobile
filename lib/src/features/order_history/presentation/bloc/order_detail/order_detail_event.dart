part of 'order_detail_bloc.dart';

abstract class OrderDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetOrderDetailEvent extends OrderDetailEvent {
  final String orderId;
  GetOrderDetailEvent({required this.orderId});
  @override
  List<Object?> get props => [orderId];
}

class OrderConfirmedEvent extends OrderDetailEvent {
  final OrderDetailEntity orderStatus;

  OrderConfirmedEvent({
    required this.orderStatus,
  });

  @override
  List<Object> get props => [orderStatus];
}

class OrderRejectedEvent extends OrderDetailEvent {
  final OrderDetailEntity orderStatus;

  OrderRejectedEvent({
    required this.orderStatus,
  });

  @override
  List<Object> get props => [orderStatus];
}

class OrderCancelledEvent extends OrderDetailEvent {
  final OrderDetailEntity orderStatus;

  OrderCancelledEvent({
    required this.orderStatus,
  });

  @override
  List<Object> get props => [orderStatus];
}

class PaymentConfirmedEvent extends OrderDetailEvent {
  final OrderDetailEntity orderStatus;

  PaymentConfirmedEvent({
    required this.orderStatus,
  });

  @override
  List<Object> get props => [orderStatus];
}

class OrderStartedEvent extends OrderDetailEvent {
  final OrderDetailEntity orderStatus;

  OrderStartedEvent({
    required this.orderStatus,
  });

  @override
  List<Object> get props => [orderStatus];
}

class OrderCompletedEvent extends OrderDetailEvent {
  final OrderDetailEntity orderStatus;

  OrderCompletedEvent({
    required this.orderStatus,
  });

  @override
  List<Object> get props => [orderStatus];
}

class OrderDetailResetEvent extends OrderDetailEvent {}
