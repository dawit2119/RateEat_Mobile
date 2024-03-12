import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data_sources/order_history_data_source.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/repositories/orders_count_repo.dart';

import '../../../../core/error/error.dart';

class OrdersCountRepoImpl extends OrdersCountRepo {
  final OrderHistoryDataSource orderHistoryDataSource;

  OrdersCountRepoImpl({required this.orderHistoryDataSource});

  @override
  Future<Either<Failure, int>> getOrdersCount(
      {required String userId, required String status}) async {
    try {
      final response = await orderHistoryDataSource.getPendingOrdersCount(
          userId: userId, status: status);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
