import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data.dart';

import '../../../../core/error/error.dart';
import '../../domain/repositories/order_history_repo.dart';

class OrderHistoryRepoImpl extends OrderHistoryRepo {
  final OrderHistoryDataSource orderHistoryDataSource;

  OrderHistoryRepoImpl({required this.orderHistoryDataSource});

  @override
  Future<Either<Failure, List<OrderHistoryModel>>> getOrderHistory({
    required String userId,
    required String status,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await orderHistoryDataSource.getOrders(
        userId: userId,
        status: status,
        page: page,
        limit: limit,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderDetailModel>> getOrderDetail(
      {required String orderId}) async {
    try {
      final order =
          await orderHistoryDataSource.getOrderDetail(orderId: orderId);
      return Right(order);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }
}
