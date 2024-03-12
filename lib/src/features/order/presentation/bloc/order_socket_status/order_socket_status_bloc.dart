import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

part 'order_socket_status_event.dart';
part 'order_socket_status_state.dart';

class OrderSocketStatusBloc
    extends Bloc<OrderSocketStatusEvent, OrderSocketStatusState> {
  OrderSocketStatusBloc() : super(OrderSocketLoadingState()) {
    on<OrderConnectSocket>(_onConnectSocketEvent);
    on<OrderSocketFailed>(_onSocketFailedEvent);
    on<OrderSocketConnected>(_onSocketConnectedEvent);
  }

  void _onConnectSocketEvent(OrderConnectSocket event, emit) async {
    emit(
      OrderSocketLoadingState(),
    );

    try {
      final socket = OrderSocketIOClient().socket!;
      if (socket.connected) {
        emit(
          OrderSocketConnectedState(),
        );
      } else if (!socket.active || socket.disconnected) {
        socket.connect();
      }
    } catch (e) {
      emit(
        OrderSocketFailedState(errorMessage: e.toString()),
      );
    }
  }

  void _onSocketFailedEvent(OrderSocketFailed event, emit) async {
    emit(
      OrderSocketFailedState(errorMessage: event.errorMessage),
    );
  }

  void _onSocketConnectedEvent(OrderSocketConnected event, emit) async {
    if (state is! OrderSocketConnectedState) {
      emit(
        OrderSocketConnectedState(),
      );
    }
  }
}
