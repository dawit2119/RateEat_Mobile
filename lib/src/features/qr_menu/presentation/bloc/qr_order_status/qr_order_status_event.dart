part of 'qr_order_status_bloc.dart';

abstract class QROrderStatusEvent extends Equatable {
  const QROrderStatusEvent();

  @override
  List<Object> get props => [];
}

class GetQROrderStatusEvent extends QROrderStatusEvent {
  final String orderId;
  const GetQROrderStatusEvent({required this.orderId});
  @override
  List<Object> get props => [orderId];
}

class QROrderConfirmedEvent extends QROrderStatusEvent {
  final QROrder orderStatus;

  const QROrderConfirmedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class QROrderRejectedEvent extends QROrderStatusEvent {
  final QROrder orderStatus;

  const QROrderRejectedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class QROrderCancelledEvent extends QROrderStatusEvent {
  final QROrder orderStatus;

  const QROrderCancelledEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class QRPaymentConfirmedEvent extends QROrderStatusEvent {
  final QROrder orderStatus;

  const QRPaymentConfirmedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class QROrderStartedEvent extends QROrderStatusEvent {
  final QROrder orderStatus;

  const QROrderStartedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}

class QROrderCompletedEvent extends QROrderStatusEvent {
  final QROrder orderStatus;

  const QROrderCompletedEvent({
    required this.orderStatus,
  });
  @override
  List<Object> get props => [orderStatus];
}
