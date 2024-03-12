import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data_sources/socket/order_history_web_socket.dart';
// import 'package:rateeat_mobile/src/features/order_history/data/data_sources/socket/order_history_web_socket.dart';

part 'order_history_status_event.dart';
part 'order_history_status_state.dart';

class OrderHistoryStatusBloc
    extends Bloc<OrderHistoryStatusEvent, OrderHistoryStatusState> {
  OrderHistoryStatusBloc() : super(OrderHistorySocketLoadingState()) {
    on<OrderHistoryConnectSocket>(_onConnectSocketEvent);
    on<OrderHistorySocketFailed>(_onSocketFailedEvent);
    on<OrderHistorySocketConnected>(_onSocketConnectedEvent);
  }

  void _onConnectSocketEvent(OrderHistoryConnectSocket event, emit) async {
    emit(
      OrderHistorySocketLoadingState(),
    );

    try {
      final socket = OrderHistoryWebSocket().socket!;
      if (socket.connected) {
        emit(
          OrderHistorySocketConnectedState(),
        );
      } else if (!socket.active || socket.disconnected) {
        socket.connect();
      }
    } catch (e) {
      emit(
        OrderHistorySocketFailed(errorMessage: e.toString()),
      );
    }
  }

  void _onSocketFailedEvent(OrderHistorySocketFailed event, emit) async {
    emit(
      OrderHistorySocketFailedState(errorMessage: event.errorMessage),
    );
  }

  void _onSocketConnectedEvent(OrderHistorySocketConnected event, emit) async {
    if (state is! OrderHistorySocketConnectedState) {
      emit(
        OrderHistorySocketConnectedState(),
      );
    }
  }
}
