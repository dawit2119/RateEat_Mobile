part of 'create_order_bloc.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();

  @override
  List<Object> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderActionsLoading extends CreateOrderState {}

class CreateOrderCreated extends CreateOrderState {
  final OrderEntity orderStatus;

  const CreateOrderCreated({
    required this.orderStatus,
  });
}

class CreateOrderActionsFailed extends CreateOrderState {
  final String errorMessage;

  const CreateOrderActionsFailed({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
