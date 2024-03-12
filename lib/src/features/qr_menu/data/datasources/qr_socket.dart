import 'package:flutter/widgets.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class QROrderSocketIOClient {
  io.Socket? socket;

  static QROrderSocketIOClient? _instance;

  QROrderSocketIOClient._() {
    socket = io.io(
      'https://rateeat-backend-server.onrender.com',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket!.connect();
    socket!.onConnect((_) {
      debugPrint("Connection success");
      dpLocator<QROrderSocketStatusBloc>().add(const QROrderSocketConnected());
    });

    socket!.onError((error) {
      dpLocator<QROrderSocketStatusBloc>()
          .add(QROrderSocketFailed(errorMessage: error.toString()));
    });

    socket!.onConnectError((error) {
      dpLocator<QROrderSocketStatusBloc>()
          .add(QROrderSocketFailed(errorMessage: error.toString()));
    });

    socket!.onReconnectFailed((error) {
      dpLocator<QROrderSocketStatusBloc>()
          .add(QROrderSocketFailed(errorMessage: error.toString()));
    });
    socket!.onerror((error) {
      dpLocator<QROrderSocketStatusBloc>()
          .add(QROrderSocketFailed(errorMessage: error.toString()));
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
        dpLocator<QROrderSocketStatusBloc>()
            .add(QROrderSocketFailed(errorMessage: data.toString()));
      }
      debugPrint("-----------------");
      debugPrint(st + "----" + data.toString());
    });
  }

  // A factory constructor to provide a way to create or get the instance
  factory QROrderSocketIOClient() {
    _instance ??= QROrderSocketIOClient._();
    return _instance!;
  }

  static QROrderSocketIOClient get instance {
    _instance ??= QROrderSocketIOClient._();
    return _instance!;
  }
}
