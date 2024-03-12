import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class CreateQROrderUsecase extends UseCase<QROrder, CreateQROrderParams> {
  final QRMenuRepository qrMenuRepository;

  CreateQROrderUsecase({
    required this.qrMenuRepository,
  });

  @override
  Future<Either<Failure, QROrder>> call(CreateQROrderParams params) async {
    return await qrMenuRepository.placeQROrder(
      restaurantId: params.restaurantId,
      items: params.items,
      orderNote: params.orderNote,
      location: params.location,
      orderType: params.orderType,
    );
  }
}

class CreateQROrderParams {
  final String restaurantId;
  final String orderNote;
  final Location location;
  final Map<QRItem, int> items;
  final String orderType;

  CreateQROrderParams({
    required this.restaurantId,
    required this.items,
    required this.orderNote,
    required this.location,
    required this.orderType,
  });
}
