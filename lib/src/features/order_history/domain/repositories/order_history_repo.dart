import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data.dart';

abstract class OrderHistoryRepo {
  Future<Either<Failure, List<OrderHistoryModel>>> getOrderHistory({
    required String userId,
    required String status,
    required int page,
    required int limit,
  });

  Future<Either<Failure, OrderDetailModel>> getOrderDetail(
      {required String orderId});
}
