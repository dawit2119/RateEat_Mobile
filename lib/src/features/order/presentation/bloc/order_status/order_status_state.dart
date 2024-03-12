part of 'order_status_bloc.dart';

abstract class OrderStatusState extends Equatable {
  const OrderStatusState();

  @override
  List<Object> get props => [];
}

class OrderStatusInitial extends OrderStatusState {}

class OrderStatusUpdatedInProgress extends OrderStatusState {}

class OrderStatusUpdateFailed extends OrderStatusState {
  final String errorMessage;
  const OrderStatusUpdateFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class OrderStatusUpdated extends OrderStatusState {
  final OrderEntity? created;
  final OrderEntity? confirmed;
  final OrderEntity? paid;
  final OrderEntity? started;
  final OrderEntity? completed;
  final OrderEntity? rejected;
  final OrderEntity? cancelled;

  const OrderStatusUpdated({
    this.created,
    this.confirmed,
    this.paid,
    this.started,
    this.completed,
    this.rejected,
    this.cancelled,
  });

  OrderStatusUpdated copyWith({
    created,
    confirmed,
    paid,
    started,
    completed,
    rejected,
    cancelled,
  }) =>
      OrderStatusUpdated(
        cancelled: cancelled ?? this.cancelled,
        created: created ?? this.created,
        confirmed: confirmed ?? this.confirmed,
        paid: paid ?? this.paid,
        started: started ?? this.started,
        completed: completed ?? this.completed,
        rejected: rejected ?? this.rejected,
      );
}

class OrderRejected extends OrderStatusState {}
