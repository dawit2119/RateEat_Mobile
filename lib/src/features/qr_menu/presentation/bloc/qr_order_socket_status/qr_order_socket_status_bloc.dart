import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/features.dart';

part 'qr_order_socket_status_event.dart';
part 'qr_order_socket_status_state.dart';

class QROrderSocketStatusBloc
    extends Bloc<QROrderSocketStatusEvent, QROrderSocketStatusState> {
  QROrderSocketStatusBloc() : super(QROrderSocketLoadingState()) {
    on<QROrderConnectSocket>(_onConnectSocketEvent);
    on<QROrderSocketFailed>(_onSocketFailedEvent);
    on<QROrderSocketConnected>(_onSocketConnectedEvent);
  }

  void _onConnectSocketEvent(QROrderConnectSocket event, emit) async {
    emit(
      QROrderSocketLoadingState(),
    );

    try {
      final socket = QROrderSocketIOClient().socket!;
      if (socket.connected) {
        emit(
          QROrderSocketConnectedState(),
        );
      } else if (!socket.active || socket.disconnected) {
        socket.connect();
      }
    } catch (e) {
      emit(
        QROrderSocketFailedState(errorMessage: e.toString()),
      );
    }
  }

  void _onSocketFailedEvent(QROrderSocketFailed event, emit) async {
    emit(
      QROrderSocketFailedState(errorMessage: event.errorMessage),
    );
  }

  void _onSocketConnectedEvent(QROrderSocketConnected event, emit) async {
    if (state is! QROrderSocketConnectedState) {
      emit(
        QROrderSocketConnectedState(),
      );
    }
  }
}
