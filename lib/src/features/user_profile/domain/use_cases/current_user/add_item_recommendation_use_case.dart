import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class AddItemRecommendationUseCase
    extends UseCase<void, ItemRecommendationUseCaseParams> {
  final AddRecommendationRepository addRecommendationRepository;

  AddItemRecommendationUseCase({required this.addRecommendationRepository});

  @override
  Future<Either<Failure, void>> call(ItemRecommendationUseCaseParams params) {
    return addRecommendationRepository.addItemRecommendation(
        params.itemId, params.message);
  }
}

class ItemRecommendationUseCaseParams {
  final String itemId;
  final String message;

  ItemRecommendationUseCaseParams(
      {required this.itemId, required this.message});
}
