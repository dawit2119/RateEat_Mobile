import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data.dart';

abstract class OrderHistoryDataSource {
  Future<List<OrderHistoryModel>> getOrders({
    required String userId,
    required String status,
    required int page,
    required int limit,
  });
  Future<int> getPendingOrdersCount(
      {required String userId, required String status});
  Future<OrderDetailModel> getOrderDetail({required String orderId});
}

class OrderHistoryDataSourceImpl implements OrderHistoryDataSource {
  final Dio dio;

  OrderHistoryDataSourceImpl({required this.dio});

  @override
  Future<List<OrderHistoryModel>> getOrders(
      {required String userId,
      required String status,
      required int page,
      required int limit}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final response = await dio.get(
        '$baseURL/orders/history?status=${status.toLowerCase()}&limit=$limit&page=$page',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token!}',
          },
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      debugPrint('response ${response.data}');
      debugPrint('response ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> orders = response.data["data"];
        var items = orders
            .map((orderDataJson) => OrderHistoryModel.fromMap(orderDataJson))
            .toList();
        return items;
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

  @override
  Future<int> getPendingOrdersCount(
      {required String userId, required String status}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      final response = await dio.get(
        '$baseURL/orders/orders-count?status=pending',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token!}',
          },
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      if (response.statusCode == 200) {
        final ordersCount = response.data["data"];
        return ordersCount;
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      }
      rethrow;
    }
  }

  @override
  Future<OrderDetailModel> getOrderDetail({required String orderId}) async {
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
        final order = OrderDetailModel.fromJson(response.data['data']);
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
