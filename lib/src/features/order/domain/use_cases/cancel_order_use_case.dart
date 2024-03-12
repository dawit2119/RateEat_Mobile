import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/domain/domain.dart';

class CancelOrderUseCase extends UseCase<bool, CancelOrderUseCaseParams> {
  final OrderRepository orderRepository;

  CancelOrderUseCase({
    required this.orderRepository,
  });
  @override
  Future<Either<Failure, bool>> call(CancelOrderUseCaseParams params) async {
    return await orderRepository.cancelOrder(
      orderId: params.orderId,
      reason: params.reason,
    );
  }
}

class CancelOrderUseCaseParams {
  final String orderId;
  final String reason;

  CancelOrderUseCaseParams({
    required this.orderId,
    required this.reason,
  });
}
