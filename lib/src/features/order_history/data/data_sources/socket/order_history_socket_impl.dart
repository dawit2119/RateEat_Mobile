import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data_sources/socket/order_history_web_socket.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

class OrderHistorySocketImpl {
  final _socketClient = OrderHistoryWebSocket.instance.socket!;

  void getOrderStatus(BuildContext context, restaurantId) {
    _socketClient.emit("joinRoom", "restaurant-$restaurantId");

    _socketClient.on('orderConfirmed', (data) {
      try {
        final order = OrderDetailModel.fromJson(data['order']);
        dpLocator<OrderDetailBloc>().add(
          OrderConfirmedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });

    _socketClient.on('orderPaymentConfirmed', (data) {
      try {
        final order = OrderDetailModel.fromJson(data['order']);
        dpLocator<OrderDetailBloc>().add(
          PaymentConfirmedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });

    _socketClient.on('orderRejected', (data) {
      try {
        final order = OrderDetailModel.fromJson(data['order']);
        dpLocator<OrderDetailBloc>().add(
          OrderRejectedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });
    _socketClient.on('orderCanceled', (data) {
      try {
        final order = OrderDetailModel.fromJson(data['order']);
        dpLocator<OrderDetailBloc>().add(
          OrderCancelledEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });

    _socketClient.on('orderPlaced', (data) {
      try {
        final order = OrderDetailModel.fromJson(data['order']);
        dpLocator<OrderDetailBloc>().add(
          OrderStartedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });

    _socketClient.on('orderCompleted', (data) {
      try {
        final order = OrderDetailModel.fromJson(data['order']);
        dpLocator<OrderDetailBloc>().add(
          OrderCompletedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });
  }
}
