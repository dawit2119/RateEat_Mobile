part of 'order_bloc.dart';

abstract class PayOrderEvent extends Equatable {
  const PayOrderEvent();

  @override
  List<Object> get props => [];
}

class CreatePaymentOrderEvent extends PayOrderEvent {
  final PaymentRequestModel paymentInfo;

  const CreatePaymentOrderEvent({
    required this.paymentInfo,
  });
}
