import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../homepage/domain/entities/item.dart';
import '../entities/total_price.dart';
import '../repositories/order_repository.dart';

class GetOrderTotalPriceUseCase
    extends UseCase<TotalPrice, GetOrderTotalPriceUseCaseParams> {
  final OrderRepository orderRepository;

  GetOrderTotalPriceUseCase({
    required this.orderRepository,
  });
  @override
  Future<Either<Failure, TotalPrice>> call(
      GetOrderTotalPriceUseCaseParams params) async {
    return await orderRepository.getTotalOrderPrice(
      params.cart,
    );
  }
}

class GetOrderTotalPriceUseCaseParams {
  final Map<Item, int> cart;

  GetOrderTotalPriceUseCaseParams({
    required this.cart,
  });
}
