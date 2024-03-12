import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class UpdateQROrderUsecase extends UseCase<QROrder, UpdateQROrderParams> {
  final QRMenuRepository qrMenuRepository;

  UpdateQROrderUsecase({required this.qrMenuRepository});
  @override
  Future<Either<Failure, QROrder>> call(params) {
    return qrMenuRepository.updateQROrder(
      orderId: params.orderId,
      items: params.orderItems,
      restaurantId: params.restaurantId,
    );
  }
}

class UpdateQROrderParams {
  final String orderId;
  final Map<QRItem, int> orderItems;
  final String restaurantId;

  UpdateQROrderParams({
    required this.orderId,
    required this.orderItems,
    required this.restaurantId,
  });
}
