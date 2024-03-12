import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/repositories/orders_count_repo.dart';

class FetchOrdersCountUseCase extends UseCase<int, OrdersCountUseCaseParams> {
  final OrdersCountRepo ordersCountRepo;

  FetchOrdersCountUseCase({required this.ordersCountRepo});

  @override
  Future<Either<Failure, int>> call(OrdersCountUseCaseParams params) {
    return ordersCountRepo.getOrdersCount(
        userId: params.userId, status: params.status);
  }
}

class OrdersCountUseCaseParams {
  final String userId;
  final String status;
  OrdersCountUseCaseParams({required this.userId, required this.status});
}
