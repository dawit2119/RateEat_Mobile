part of 'qr_order_status_bloc.dart';

abstract class QROrderStatusState extends Equatable {
  const QROrderStatusState();

  @override
  List<Object> get props => [];
}

class QROrderStatusInitial extends QROrderStatusState {}

class QROrderStatusUpdatedInProgress extends QROrderStatusState {}

class QROrderStatusUpdateFailed extends QROrderStatusState {
  final String errorMessage;
  const QROrderStatusUpdateFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class QROrderStatusUpdated extends QROrderStatusState {
  final QROrder? created;
  final QROrder? confirmed;
  final QROrder? paid;
  final QROrder? started;
  final QROrder? completed;
  final QROrder? rejected;
  final QROrder? cancelled;

  const QROrderStatusUpdated({
    this.created,
    this.confirmed,
    this.paid,
    this.started,
    this.completed,
    this.rejected,
    this.cancelled,
  });

  QROrderStatusUpdated copyWith({
    created,
    confirmed,
    paid,
    started,
    completed,
    rejected,
    cancelled,
  }) =>
      QROrderStatusUpdated(
        cancelled: cancelled ?? this.cancelled,
        created: created ?? this.created,
        confirmed: confirmed ?? this.confirmed,
        paid: paid ?? this.paid,
        started: started ?? this.started,
        completed: completed ?? this.completed,
        rejected: rejected ?? this.rejected,
      );
}

class QROrderRejected extends QROrderStatusState {}
