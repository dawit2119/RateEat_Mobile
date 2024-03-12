import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class OrderHistoryWebSocket {
  io.Socket? socket;
  String? restaurantId;

  static OrderHistoryWebSocket? _instance;

  OrderHistoryWebSocket._() {
    socket = io.io(
      "https://rateeat-backend-ij7jnmwh2q-zf.a.run.app",
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint("Connected");
      dpLocator<OrderHistoryStatusBloc>()
          .add(const OrderHistorySocketConnected());
    });

    socket!.onError((error) {
      dpLocator<OrderHistoryStatusBloc>()
          .add(OrderHistorySocketFailed(errorMessage: error.toString()));
    });

    socket!.onConnectError((error) {
      dpLocator<OrderHistoryStatusBloc>()
          .add(OrderHistorySocketFailed(errorMessage: error.toString()));
    });

    socket!.onReconnectFailed((error) {
      dpLocator<OrderHistoryStatusBloc>()
          .add(OrderHistorySocketFailed(errorMessage: error.toString()));
    });
    socket!.onerror((error) {
      dpLocator<OrderHistoryStatusBloc>()
          .add(OrderHistorySocketFailed(errorMessage: error.toString()));
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
        dpLocator<OrderHistoryStatusBloc>()
            .add(OrderHistorySocketFailed(errorMessage: data.toString()));
      }
    });
  }

  // A factory constructor to provide a way to create or get the instance
  factory OrderHistoryWebSocket() {
    _instance ??= OrderHistoryWebSocket._();
    return _instance!;
  }

  static OrderHistoryWebSocket get instance {
    _instance ??= OrderHistoryWebSocket._();
    return _instance!;
  }
}
