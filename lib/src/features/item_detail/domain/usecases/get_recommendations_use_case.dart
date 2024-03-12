import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/domain.dart';

import '../../../homepage/domain/entities/item.dart';

class GetItemRecommendationsUseCase extends UseCase<List<Item>, String> {
  final ItemRepository recommendationRepository;
  GetItemRecommendationsUseCase({required this.recommendationRepository});

  @override
  Future<Either<Failure, List<Item>>> call(params) async {
    return await recommendationRepository.getItemRecommendations(
        itemId: params);
  }
}
