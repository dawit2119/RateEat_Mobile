import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource orderDataSource;

  OrderRepositoryImpl({
    required this.orderDataSource,
  });

  @override
  Future<Either<Failure, TotalPrice>> getTotalOrderPrice(
      Map<Item, int> cart) async {
    try {
      final finalOrderPrice = await orderDataSource.getTotalPrice(cart);
      return Right(finalOrderPrice);
    } catch (e) {
      return Left(
        mapExceptionToFailure(
          exception: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderModel order) async {
    try {
      final finalOrderPrice = await orderDataSource.createOrder(order);
      return Right(finalOrderPrice);
    } catch (e) {
      return Left(
        mapExceptionToFailure(
          exception: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> pay(
      {required PaymentRequestModel paymentInfo}) async {
    try {
      final returnUrl = await orderDataSource.pay(paymentInfo: paymentInfo);
      return Right(returnUrl);
    } catch (e) {
      return Left(
        mapExceptionToFailure(
          exception: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> cancelOrder(
      {required String orderId, required String reason}) async {
    try {
      final response = await orderDataSource.cancelOrder(
        orderId: orderId,
        reason: reason,
      );
      return Right(response);
    } catch (e) {
      return Left(
        mapExceptionToFailure(
          exception: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderStatus(
      {required String orderId}) async {
    try {
      final order = await orderDataSource.getOrderStatus(orderId: orderId);
      return Right(order);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }
}
