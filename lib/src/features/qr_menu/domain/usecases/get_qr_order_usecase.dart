import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class GetQROrderUsecase extends UseCase<QROrder, String> {
  final QRMenuRepository qrMenuRepository;

  GetQROrderUsecase({required this.qrMenuRepository});

  @override
  Future<Either<Failure, QROrder>> call(String params) {
    return qrMenuRepository.getQROrder(orderId: params);
  }
}
