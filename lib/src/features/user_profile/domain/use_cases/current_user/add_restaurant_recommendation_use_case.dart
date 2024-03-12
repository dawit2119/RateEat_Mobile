import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class AddRestaurantRecommendationUseCase
    extends UseCase<void, RetaurantecommendationUseCaseParams> {
  final AddRecommendationRepository addRecommendationRepository;

  AddRestaurantRecommendationUseCase(
      {required this.addRecommendationRepository});

  @override
  Future<Either<Failure, void>> call(
      RetaurantecommendationUseCaseParams params) {
    return addRecommendationRepository.addRestaurantRecommendation(
        params.restaurantId, params.message);
  }
}

class RetaurantecommendationUseCaseParams {
  final String restaurantId;
  final String message;

  RetaurantecommendationUseCaseParams(
      {required this.restaurantId, required this.message});
}
