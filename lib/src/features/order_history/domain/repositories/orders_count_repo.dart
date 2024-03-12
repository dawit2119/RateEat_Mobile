import 'package:dartz/dartz.dart';

import '../../../../core/error/error.dart';

abstract class OrdersCountRepo {
  Future<Either<Failure, int>> getOrdersCount(
      {required String userId, required String status});
}
