import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class QROrderSocketMethod {
  final _socketClient = QROrderSocketIOClient.instance.socket!;
  void getOrderStatus(BuildContext context, restaurantId) {
    _socketClient.emit("joinRoom",
        "user-${dpLocator<AuthenticationLocalSource>().getUserCredential()?.id}");

    _socketClient.onAny((st, data) {
      if (st == "connect_error") {
        dpLocator<QROrderSocketStatusBloc>()
            .add(QROrderSocketFailed(errorMessage: data.toString()));
      }
      debugPrint("-----------------");
      debugPrint(st + "----" + data.toString());
    });

    _socketClient.on('orderConfirmed', (data) {
      try {
        final order = QROrderModel.fromMap(data['order']);
        dpLocator<QROrderStatusBloc>().add(
          QROrderConfirmedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });

    _socketClient.on('orderPaymentConfirmed', (data) {
      try {
        final order = QROrderModel.fromMap(data['order']);
        dpLocator<QROrderStatusBloc>().add(
          QRPaymentConfirmedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });

    _socketClient.on('orderRejected', (data) {
      try {
        final order = QROrderModel.fromMap(data['order']);
        dpLocator<QROrderStatusBloc>().add(
          QROrderRejectedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });
    _socketClient.on('orderCanceled', (data) {
      try {
        final order = QROrderModel.fromMap(data['order']);
        dpLocator<QROrderStatusBloc>().add(
          QROrderRejectedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });

    _socketClient.on('orderPlaced', (data) {
      try {
        final order = QROrderModel.fromMap(data['order']);
        dpLocator<QROrderStatusBloc>().add(
          QROrderStartedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });

    _socketClient.on('orderCompleted', (data) {
      try {
        final order = QROrderModel.fromMap(data['order']);
        dpLocator<QROrderStatusBloc>().add(
          QROrderCompletedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });
  }
}
