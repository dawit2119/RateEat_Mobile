part of 'create_order_bloc.dart';

abstract class CreateOrderEvent extends Equatable {
  const CreateOrderEvent();

  @override
  List<Object> get props => [];
}

class CreateNewOrderEvent extends CreateOrderEvent {
  final OrderModel order;

  const CreateNewOrderEvent({
    required this.order,
  });
}
