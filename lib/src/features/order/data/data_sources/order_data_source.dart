import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

import '../../../homepage/domain/entities/item.dart';

abstract class OrderDataSource {
  Future<TotalPrice> getTotalPrice(Map<Item, int> cart);
  Future<OrderModel> createOrder(OrderModel order);
  Future<String> pay({required PaymentRequestModel paymentInfo});
  Future<bool> cancelOrder({required String orderId, required String reason});
  Future<OrderModel> getOrderStatus({required String orderId});
}

class OrderDataSourceImpl implements OrderDataSource {
  final Dio dio;
  OrderDataSourceImpl({
    required this.dio,
  });
  @override
  Future<TotalPrice> getTotalPrice(Map<Item, int> cart) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      debugPrint('cart $cart');
      final url = "$baseURL/orders/calculate-total-price/items";
      final items = {
        "items": cart.entries
            .map((e) => {"itemId": e.key.itemId, "quantity": e.value})
            .toList()
      };

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token}'
          },
        ),
        data: items,
      );

      debugPrint('response $response');

      if (response.statusCode == 200) {
        return TotalPriceModel.fromMap(response.data['data']);
      } else {
        throw ServerException(errorMessage: 'Failed to get total price');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: e.toString());
      }
    }
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final url = '$baseURL/orders';
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token}',
          },
        ),
        data: order.toJson(),
      );

      if (response.statusCode == 201) {
        return OrderModel.fromJson(
          response.data['data'],
        );
      } else {
        throw ServerException(errorMessage: 'Failed to create Order');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: e.toString());
      }
    }
  }

  @override
  Future<String> pay({required PaymentRequestModel paymentInfo}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final response = await dio.post(
        '$baseURL/payments/pay',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token}',
          },
        ),
        data: json.encode(paymentInfo.toJson()),
      );
      if (response.statusCode == 200) {
        return response.data['data']['payment_url'];
      } else {
        throw ServerException(errorMessage: 'failed to get payment info');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response!.statusCode == 409) {
          return e.response!.data['data']['payment_url'];
        }
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: e.toString());
      }
    }
  }

  @override
  Future<bool> cancelOrder(
      {required String orderId, required String reason}) async {
    final url = '$baseURL/orders/$orderId/cancel-order';
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final response = await dio.put(
        url,
        options: Options(
          headers: {
            'Content-Type': 'applicatimatcherteon/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token}',
          },
        ),
        data: json.encode({"reason": reason}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException(errorMessage: 'Failed to cancel order');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
          errorMessage: e.response?.data['message'] ?? e.message,
        );
      } else {
        throw ServerException(errorMessage: e.toString());
      }
    }
  }

  @override
  Future<OrderModel> getOrderStatus({required String orderId}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (user != null) {
        headers.addEntries([
          MapEntry('Authorization', 'Bearer ${user.token}'),
        ]);
      }
      final response = await dio.get(
        "$baseURL/orders/$orderId",
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        final order = OrderModel.fromJson(response.data['data']);
        return order;
      } else {
        throw ServerException(errorMessage: 'Failed to load Order');
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      }
      rethrow;
    }
  }
}
