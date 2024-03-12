import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/domain.dart';

part 'order_detail_event.dart';
part 'order_detail_state.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final GetOrderDetailUseCase orderUseCase;

  OrderDetailBloc({required this.orderUseCase}) : super(OrderDetailInitial()) {
    on<GetOrderDetailEvent>(_onGetOrder);
    on<OrderConfirmedEvent>(_onOrderConfirmedEvent);
    on<PaymentConfirmedEvent>(_onPaymentCompletedEvent);
    on<OrderStartedEvent>(_onOrderStartedEvent);
    on<OrderCompletedEvent>(_onOrderCompletedEvent);
    on<OrderRejectedEvent>(_onOrderRejectedEvent);
    on<OrderCancelledEvent>(_onOrderCancelledEvent);
    on<OrderDetailResetEvent>(_onOrderDetailResetEvent);
  }
  void _onGetOrder(
      GetOrderDetailEvent event, Emitter<OrderDetailState> emit) async {
    emit(OrderHistoryStatusUpdatedInProgress());

    Either<Failure, OrderDetailModel> response =
        await orderUseCase(GetOrderDetailParams(orderId: event.orderId));

    emit(_eitherFailureOrOrder(response));
  }

  OrderDetailState _eitherFailureOrOrder(
      Either<Failure, OrderDetailModel> response) {
    return response.fold(
      (error) => OrderDetailError(errorMessage: error.errorMessage),
      (order) => OrderHistoryStatusUpdated(
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
    var currentState = (state is OrderHistoryStatusUpdated)
        ? state as OrderHistoryStatusUpdated
        : state;

    emit(
      OrderHistoryStatusUpdatedInProgress(),
    );
    if (currentState is OrderHistoryStatusUpdated) {
      currentState = currentState.copyWith(confirmed: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderHistoryStatusUpdated(
          confirmed: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderRejectedEvent(OrderRejectedEvent event, emit) async {
    var currentState = (state is OrderHistoryStatusUpdated)
        ? state as OrderHistoryStatusUpdated
        : state;

    emit(
      OrderHistoryStatusUpdatedInProgress(),
    );
    if (currentState is OrderHistoryStatusUpdated) {
      currentState = currentState.copyWith(rejected: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderHistoryStatusUpdated(
          rejected: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderCancelledEvent(OrderCancelledEvent event, emit) async {
    var currentState = (state is OrderHistoryStatusUpdated)
        ? state as OrderHistoryStatusUpdated
        : state;

    emit(
      OrderHistoryStatusUpdatedInProgress(),
    );
    if (currentState is OrderHistoryStatusUpdated) {
      currentState = currentState.copyWith(cancelled: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderHistoryStatusUpdated(
          cancelled: event.orderStatus,
        ),
      );
    }
  }

  void _onPaymentCompletedEvent(PaymentConfirmedEvent event, emit) async {
    var currentState = (state is OrderHistoryStatusUpdated)
        ? state as OrderHistoryStatusUpdated
        : state;

    emit(
      OrderHistoryStatusUpdatedInProgress(),
    );
    if (currentState is OrderHistoryStatusUpdated) {
      currentState = currentState.copyWith(paid: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderHistoryStatusUpdated(
          paid: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderStartedEvent(OrderStartedEvent event, emit) async {
    var currentState = (state is OrderHistoryStatusUpdated)
        ? state as OrderHistoryStatusUpdated
        : state;

    emit(
      OrderHistoryStatusUpdatedInProgress(),
    );
    if (currentState is OrderHistoryStatusUpdated) {
      currentState = currentState.copyWith(started: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderHistoryStatusUpdated(
          started: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderCompletedEvent(OrderCompletedEvent event, emit) async {
    var currentState = (state is OrderHistoryStatusUpdated)
        ? state as OrderHistoryStatusUpdated
        : state;

    emit(
      OrderHistoryStatusUpdatedInProgress(),
    );
    if (currentState is OrderHistoryStatusUpdated) {
      currentState = currentState.copyWith(completed: event.orderStatus);
      emit(currentState);
    } else {
      emit(
        OrderHistoryStatusUpdated(
          completed: event.orderStatus,
        ),
      );
    }
  }

  void _onOrderDetailResetEvent(OrderDetailResetEvent event, emit) async {
    emit(
      OrderHistoryStatusUpdatedInProgress(),
    );
  }
}
