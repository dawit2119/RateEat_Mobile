import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/repositories/order_history_repo.dart';

import '../../data/models/order_history_model/order_history.dart';

class FetchOrderHistoryUseCase
    extends UseCase<List<OrderHistoryModel>, OrderHistoryUseCaseParams> {
  final OrderHistoryRepo orderHistoryRepo;

  FetchOrderHistoryUseCase({required this.orderHistoryRepo});

  @override
  Future<Either<Failure, List<OrderHistoryModel>>> call(
      OrderHistoryUseCaseParams params) {
    return orderHistoryRepo.getOrderHistory(
      userId: params.userId,
      status: params.status,
      page: params.page,
      limit: params.limit,
    );
  }
}

class OrderHistoryUseCaseParams {
  final String userId;
  final String status;
  final int page;
  final int limit;
  OrderHistoryUseCaseParams({
    required this.userId,
    required this.status,
    required this.page,
    required this.limit,
  });
}
