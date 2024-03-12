import 'package:flutter/widgets.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class OrderSocketIOClient {
  io.Socket? socket;

  static OrderSocketIOClient? _instance;

  OrderSocketIOClient._() {
    socket = io.io(
      'https://rateeat-backend-ij7jnmwh2q-zf.a.run.app',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket!.connect();
    socket!.onConnect((_) {
      debugPrint("Connection success");
      dpLocator<OrderSocketStatusBloc>().add(const OrderSocketConnected());
    });

    socket!.onError((error) {
      dpLocator<OrderSocketStatusBloc>()
          .add(OrderSocketFailed(errorMessage: error.toString()));
    });

    socket!.onConnectError((error) {
      dpLocator<OrderSocketStatusBloc>()
          .add(OrderSocketFailed(errorMessage: error.toString()));
    });

    socket!.onReconnectFailed((error) {
      dpLocator<OrderSocketStatusBloc>()
          .add(OrderSocketFailed(errorMessage: error.toString()));
    });
    socket!.onerror((error) {
      dpLocator<OrderSocketStatusBloc>()
          .add(OrderSocketFailed(errorMessage: error.toString()));
    });

    socket!.onConnect((_) {
      debugPrint("Connecting");
    });
    socket!.onReconnect((_) {
      debugPrint("Reconnecting");
    });

    socket!.onDisconnect((_) {
      debugPrint("Disconnecting");
    });

    socket!.onAny((st, data) {
      if (st == "connect_error") {
        dpLocator<OrderSocketStatusBloc>()
            .add(OrderSocketFailed(errorMessage: data.toString()));
      }
    });
  }

  // A factory constructor to provide a way to create or get the instance
  factory OrderSocketIOClient() {
    _instance ??= OrderSocketIOClient._();
    return _instance!;
  }

  static OrderSocketIOClient get instance {
    _instance ??= OrderSocketIOClient._();
    return _instance!;
  }
}
