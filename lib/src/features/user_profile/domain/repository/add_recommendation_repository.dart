import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

abstract class AddRecommendationRepository {
  Future<Either<Failure, void>> addItemRecommendation(
      String itemId, String message);
  Future<Either<Failure, void>> addRestaurantRecommendation(
      String restaurntId, String message);
}
