import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

part 'order_status_event.dart';
part 'order_status_state.dart';

class OrderStatusBloc extends Bloc<OrderStatusEvent, OrderStatusState> {
  final GetOrderStatusUseCase orderStatusUseCase;

  OrderStatusBloc({required this.orderStatusUseCase})
      : super(OrderStatusInitial()) {
    on<GetOrderStatusEvent>(_onGetOrder);
    on<OrderConfirmedEvent>(_onOrderConfirmedEvent);
    on<PaymentConfirmedEvent>(_onPaymentCompletedEvent);
    on<OrderStartedEvent>(_onOrderStartedEvent);
    on<OrderCompletedEvent>(_onOrderCompletedEvent);
    on<OrderRejectedEvent>(_onOrderRejectedEvent);
    on<OrderCancelledEvent>(_onOrderCancelledEvent);
  }

  void _onGetOrder(
      GetOrderStatusEvent event, Emitter<OrderStatusState> emit) async {
    emit(OrderStatusUpdatedInProgress());

    Either<Failure, OrderModel> response =
        await orderStatusUseCase(GetOrderStatusParams(orderId: event.orderId));

    emit(_eitherFailureOrOrder(response));
  }

  OrderStatusState _eitherFailureOrOrder(Either<Failure, OrderModel> response) {
    return response.fold(
      (error) => OrderStatusUpdateFailed(errorMessage: error.errorMessage),
      (order) => OrderStatusUpdated(
        created: order,
        confirmed: order.orderConfirmedAt != null ? order : null,
        paid: order.paymentConfirmedAt != null ? order : null,
        started: order.orderPlacedAt != null ? order : null,
        completed: order.orderCompletedAt != null ? order : null,
        rejected: order.orderRejectedAt != null ? order : null,
        cancelled: order.orderCanceledAt != null ? order : null,
      ),
    );
  }

  void _onOrderConfirmedEvent(OrderConfirmedEvent event, emit) async {
    var currentState =
        (state is OrderStatusUpdated) ? state as OrderStatusUpdated : state;

    emit(
      OrderStatusUpdatedInProgress(),
    );
    if (currentState is OrderStatusUpdated) {
      currentState = currentState.copyWith(confirmed: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderStatusUpdated(
          confirmed: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderRejectedEvent(OrderRejectedEvent event, emit) async {
    var currentState =
        (state is OrderStatusUpdated) ? state as OrderStatusUpdated : state;

    emit(
      OrderStatusUpdatedInProgress(),
    );
    if (currentState is OrderStatusUpdated) {
      currentState = currentState.copyWith(rejected: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderStatusUpdated(
          rejected: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderCancelledEvent(OrderCancelledEvent event, emit) async {
    var currentState =
        (state is OrderStatusUpdated) ? state as OrderStatusUpdated : state;

    emit(
      OrderStatusUpdatedInProgress(),
    );
    if (currentState is OrderStatusUpdated) {
      currentState = currentState.copyWith(cancelled: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderStatusUpdated(
          cancelled: event.orderStatus,
        ),
      );
    }
  }

  void _onPaymentCompletedEvent(PaymentConfirmedEvent event, emit) async {
    var currentState =
        (state is OrderStatusUpdated) ? state as OrderStatusUpdated : state;

    emit(
      OrderStatusUpdatedInProgress(),
    );
    if (currentState is OrderStatusUpdated) {
      currentState = currentState.copyWith(paid: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderStatusUpdated(
          paid: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderStartedEvent(OrderStartedEvent event, emit) async {
    var currentState =
        (state is OrderStatusUpdated) ? state as OrderStatusUpdated : state;

    emit(
      OrderStatusUpdatedInProgress(),
    );
    if (currentState is OrderStatusUpdated) {
      currentState = currentState.copyWith(started: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderStatusUpdated(
          started: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderCompletedEvent(OrderCompletedEvent event, emit) async {
    var currentState =
        (state is OrderStatusUpdated) ? state as OrderStatusUpdated : state;

    emit(
      OrderStatusUpdatedInProgress(),
    );
    if (currentState is OrderStatusUpdated) {
      currentState = currentState.copyWith(completed: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderStatusUpdated(
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
