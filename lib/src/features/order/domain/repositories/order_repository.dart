import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, TotalPrice>> getTotalOrderPrice(Map<Item, int> cart);
  Future<Either<Failure, OrderEntity>> createOrder(OrderModel order);
  Future<Either<Failure, String>> pay(
      {required PaymentRequestModel paymentInfo});
  Future<Either<Failure, bool>> cancelOrder(
      {required String orderId, required String reason});

  Future<Either<Failure, OrderModel>> getOrderStatus({required String orderId});
}
