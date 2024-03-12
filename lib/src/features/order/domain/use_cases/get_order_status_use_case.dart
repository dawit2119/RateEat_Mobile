import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

class GetOrderStatusUseCase extends UseCase<OrderModel, GetOrderStatusParams> {
  final OrderRepository orderRepository;

  GetOrderStatusUseCase({required this.orderRepository});

  @override
  Future<Either<Failure, OrderModel>> call(params) async {
    return await orderRepository.getOrderStatus(orderId: params.orderId);
  }
}

class GetOrderStatusParams extends Equatable {
  final String orderId;

  const GetOrderStatusParams({
    required this.orderId,
  });

  @override
  List<Object> get props => [orderId];
}
