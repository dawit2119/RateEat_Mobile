part of 'order_bloc.dart';

abstract class PayOrderState extends Equatable {
  const PayOrderState();

  @override
  List<Object> get props => [];
}

class PaymentOrderInitial extends PayOrderState {}

class PaymentOrderActionsLoading extends PayOrderState {}

class PaymentOrderCreated extends PayOrderState {
  final String returnUrl;

  const PaymentOrderCreated({
    required this.returnUrl,
  });
}

class PaymentOrderActionsFailed extends PayOrderState {
  final String errorMessage;

  const PaymentOrderActionsFailed({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
