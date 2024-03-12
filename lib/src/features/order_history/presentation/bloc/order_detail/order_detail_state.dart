part of 'order_detail_bloc.dart';

abstract class OrderDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderDetailInitial extends OrderDetailState {}

class OrderHistoryStatusUpdatedInProgress extends OrderDetailState {}

class OrderDetailError extends OrderDetailState {
  final String errorMessage;
  OrderDetailError({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class OrderHistoryStatusUpdated extends OrderDetailState {
  final OrderDetailEntity? created;
  final OrderDetailEntity? confirmed;
  final OrderDetailEntity? paid;
  final OrderDetailEntity? started;
  final OrderDetailEntity? completed;
  final OrderDetailEntity? rejected;
  final OrderDetailEntity? cancelled;

  OrderHistoryStatusUpdated({
    this.created,
    this.confirmed,
    this.paid,
    this.started,
    this.completed,
    this.rejected,
    this.cancelled,
  });

  OrderHistoryStatusUpdated copyWith({
    OrderDetailEntity? created,
    OrderDetailEntity? confirmed,
    OrderDetailEntity? paid,
    OrderDetailEntity? started,
    OrderDetailEntity? completed,
    OrderDetailEntity? rejected,
    OrderDetailEntity? cancelled,
  }) =>
      OrderHistoryStatusUpdated(
        created: created ?? this.created,
        confirmed: confirmed ?? this.confirmed,
        paid: paid ?? this.paid,
        started: started ?? this.started,
        completed: completed ?? this.completed,
        rejected: rejected ?? this.rejected,
        cancelled: cancelled ?? this.cancelled,
      );
}

class OrderRejected extends OrderDetailState {}
