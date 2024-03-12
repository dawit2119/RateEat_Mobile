import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

part 'qr_order_status_event.dart';
part 'qr_order_status_state.dart';

class QROrderStatusBloc extends Bloc<QROrderStatusEvent, QROrderStatusState> {
  final GetQROrderUsecase orderStatusUseCase;

  QROrderStatusBloc({required this.orderStatusUseCase})
      : super(QROrderStatusInitial()) {
    on<GetQROrderStatusEvent>(_onGetOrder);
    on<QROrderConfirmedEvent>(_onOrderConfirmedEvent);
    on<QRPaymentConfirmedEvent>(_onPaymentCompletedEvent);
    on<QROrderStartedEvent>(_onOrderStartedEvent);
    on<QROrderCompletedEvent>(_onOrderCompletedEvent);
    on<QROrderRejectedEvent>(_onOrderRejectedEvent);
    on<QROrderCancelledEvent>(_onOrderCancelledEvent);
  }

  void _onGetOrder(
      GetQROrderStatusEvent event, Emitter<QROrderStatusState> emit) async {
    emit(QROrderStatusUpdatedInProgress());

    Either<Failure, QROrder> response = await orderStatusUseCase(event.orderId);

    emit(_eitherFailureOrOrder(response));
  }

  QROrderStatusState _eitherFailureOrOrder(Either<Failure, QROrder> response) {
    return response.fold(
      (error) => QROrderStatusUpdateFailed(errorMessage: error.errorMessage),
      (order) => QROrderStatusUpdated(
        created: order,
        confirmed: order.orderConfirmedAt != null ? order : null,
        paid: order.paymentConfirmedAt != null ? order : null,
        started: order.orderPlacedAt != null ? order : null,
        completed: order.orderCompletedAt != null ? order : null,
        rejected: order.orderRejectedAt != null ? order : null,
        cancelled: order.orderCancelledAt != null ? order : null,
      ),
    );
  }

  void _onOrderConfirmedEvent(QROrderConfirmedEvent event, emit) async {
    var currentState =
        (state is QROrderStatusUpdated) ? state as QROrderStatusUpdated : state;

    emit(
      QROrderStatusUpdatedInProgress(),
    );
    if (currentState is QROrderStatusUpdated) {
      currentState = currentState.copyWith(confirmed: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        QROrderStatusUpdated(
          confirmed: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderRejectedEvent(QROrderRejectedEvent event, emit) async {
    var currentState =
        (state is QROrderStatusUpdated) ? state as QROrderStatusUpdated : state;

    emit(
      QROrderStatusUpdatedInProgress(),
    );
    if (currentState is QROrderStatusUpdated) {
      currentState = currentState.copyWith(rejected: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        QROrderStatusUpdated(
          rejected: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderCancelledEvent(QROrderCancelledEvent event, emit) async {
    var currentState =
        (state is QROrderStatusUpdated) ? state as QROrderStatusUpdated : state;

    emit(
      QROrderStatusUpdatedInProgress(),
    );
    if (currentState is QROrderStatusUpdated) {
      currentState = currentState.copyWith(cancelled: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        QROrderStatusUpdated(
          cancelled: event.orderStatus,
        ),
      );
    }
  }

  void _onPaymentCompletedEvent(QRPaymentConfirmedEvent event, emit) async {
    var currentState =
        (state is QROrderStatusUpdated) ? state as QROrderStatusUpdated : state;

    emit(
      QROrderStatusUpdatedInProgress(),
    );
    if (currentState is QROrderStatusUpdated) {
      currentState = currentState.copyWith(paid: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        QROrderStatusUpdated(
          paid: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderStartedEvent(QROrderStartedEvent event, emit) async {
    var currentState =
        (state is QROrderStatusUpdated) ? state as QROrderStatusUpdated : state;

    emit(
      QROrderStatusUpdatedInProgress(),
    );
    if (currentState is QROrderStatusUpdated) {
      currentState = currentState.copyWith(started: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        QROrderStatusUpdated(
          started: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderCompletedEvent(QROrderCompletedEvent event, emit) async {
    var currentState =
        (state is QROrderStatusUpdated) ? state as QROrderStatusUpdated : state;

    emit(
      QROrderStatusUpdatedInProgress(),
    );
    if (currentState is QROrderStatusUpdated) {
      currentState = currentState.copyWith(completed: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        QROrderStatusUpdated(
          completed: event.orderStatus,
        ),
      );
    }
  }

  // void _onGetOrderStatusEvent(GetOrderStatusEvent event, emit) async {
  //   emit(
  //     OrderStatusInitial(),
  //   );
  // }
}
