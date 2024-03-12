import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

class CreateOrderUseCase
    extends UseCase<OrderEntity, CreateOrderUseCaseParams> {
  final OrderRepository orderRepository;

  CreateOrderUseCase({
    required this.orderRepository,
  });
  @override
  Future<Either<Failure, OrderEntity>> call(
      CreateOrderUseCaseParams params) async {
    return await orderRepository.createOrder(
      params.order,
    );
  }
}

class CreateOrderUseCaseParams {
  final OrderModel order;

  CreateOrderUseCaseParams({
    required this.order,
  });
}
