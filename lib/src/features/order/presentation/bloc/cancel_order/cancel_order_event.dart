part of 'cancel_order_bloc.dart';

abstract class CancelOrderEvent extends Equatable {
  const CancelOrderEvent();

  @override
  List<Object> get props => [];
}

class CancelOrderRequestEvent extends CancelOrderEvent {
  final String orderId;
  final String reason;

  const CancelOrderRequestEvent({
    required this.orderId,
    required this.reason,
  });
}
