part of 'cancel_order_bloc.dart';

abstract class CancelOrderState extends Equatable {
  const CancelOrderState();

  @override
  List<Object> get props => [];
}

class CancelOrderRequestInitial extends CancelOrderState {}

class CancelOrderRequestLoading extends CancelOrderState {}

class CancelOrderRequestSuccess extends CancelOrderState {
  final bool status;

  const CancelOrderRequestSuccess({
    required this.status,
  });
}

class CancelOrderRequestFailed extends CancelOrderState {
  final String errorMessage;

  const CancelOrderRequestFailed({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
