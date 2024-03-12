import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data.dart';
import 'package:rateeat_mobile/src/features/order_history/domain/domain.dart';

class GetOrderDetailUseCase
    extends UseCase<OrderDetailModel, GetOrderDetailParams> {
  final OrderHistoryRepo orderHistoryRepo;

  GetOrderDetailUseCase({required this.orderHistoryRepo});

  @override
  Future<Either<Failure, OrderDetailModel>> call(params) async {
    return await orderHistoryRepo.getOrderDetail(orderId: params.orderId);
  }
}

class GetOrderDetailParams extends Equatable {
  final String orderId;

  const GetOrderDetailParams({
    required this.orderId,
  });

  @override
  List<Object> get props => [orderId];
}
