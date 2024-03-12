import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

class OrderSocketMethod {
  final _socketClient = OrderSocketIOClient.instance.socket!;
  void getOrderStatus(BuildContext context, restaurantId) {
    _socketClient.emit("joinRoom", "restaurant-$restaurantId");

    _socketClient.on('orderConfirmed', (data) {
      try {
        final order = OrderModel.fromJson(data['order']);
        dpLocator<OrderStatusBloc>().add(
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
        final order = OrderModel.fromJson(data['order']);
        dpLocator<OrderStatusBloc>().add(
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
        final order = OrderModel.fromJson(data['order']);
        dpLocator<OrderStatusBloc>().add(
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
        final order = OrderModel.fromJson(data['order']);
        dpLocator<OrderStatusBloc>().add(
          OrderRejectedEvent(
            orderStatus: order,
          ),
        );
      } catch (e) {
        debugPrint("The exception is ${e.toString()}");
      }
    });

    _socketClient.on('orderPlaced', (data) {
      try {
        final order = OrderModel.fromJson(data['order']);
        dpLocator<OrderStatusBloc>().add(
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
        final order = OrderModel.fromJson(data['order']);
        dpLocator<OrderStatusBloc>().add(
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
