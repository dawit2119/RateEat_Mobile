import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class GetPromotionUseCase extends UseCase<List<Promotion>, NoParams> {
  final HomeRepository repository;

  GetPromotionUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<Promotion>>> call(NoParams params) async {
    return await repository.getPromotions();
  }
}
