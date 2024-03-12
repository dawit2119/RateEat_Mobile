import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

class AddRecommendationRepositoryImpl extends AddRecommendationRepository {
  final AddRecommendationDataProvider addRecommendationDataProvider;

  AddRecommendationRepositoryImpl(
      {required this.addRecommendationDataProvider});
  @override
  Future<Either<Failure, void>> addItemRecommendation(
      String itemId, String message) async {
    try {
      return Right(await addRecommendationDataProvider.addItemRecommendation(
          itemId, message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addRestaurantRecommendation(
      String restaurntId, String message) async {
    try {
      return Right(await addRecommendationDataProvider
          .addRestaurantRecommendation(restaurntId, message));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
