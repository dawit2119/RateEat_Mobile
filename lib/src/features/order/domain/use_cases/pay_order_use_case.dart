import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/data/data.dart';

import '../repositories/order_repository.dart';

class PayOrderUseCase extends UseCase<String, PaymentRequestUseCaseParams> {
  final OrderRepository orderRepository;

  PayOrderUseCase({
    required this.orderRepository,
  });
  @override
  Future<Either<Failure, String>> call(
      PaymentRequestUseCaseParams params) async {
    return await orderRepository.pay(paymentInfo: params.paymentInfo);
  }
}

class PaymentRequestUseCaseParams {
  final PaymentRequestModel paymentInfo;

  PaymentRequestUseCaseParams({
    required this.paymentInfo,
  });
}
