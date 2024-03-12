part of 'order_status_bloc.dart';

abstract class OrderStatusEvent extends Equatable {
  const OrderStatusEvent();

  @override
  List<Object> get props => [];
}

class GetOrderStatusEvent extends OrderStatusEvent {
  final String orderId;
  const GetOrderStatusEvent({required this.orderId});
  @override
  List<Object> get props => [orderId];
}

class OrderConfirmedEvent extends OrderStatusEvent {
  final OrderEntity orderStatus;

  const OrderConfirmedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class OrderRejectedEvent extends OrderStatusEvent {
  final OrderEntity orderStatus;

  const OrderRejectedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class OrderCancelledEvent extends OrderStatusEvent {
  final OrderEntity orderStatus;

  const OrderCancelledEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class PaymentConfirmedEvent extends OrderStatusEvent {
  final OrderEntity orderStatus;

  const PaymentConfirmedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class OrderStartedEvent extends OrderStatusEvent {
  final OrderEntity orderStatus;

  const OrderStartedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class OrderCompletedEvent extends OrderStatusEvent {
  final OrderEntity orderStatus;

  const OrderCompletedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}
