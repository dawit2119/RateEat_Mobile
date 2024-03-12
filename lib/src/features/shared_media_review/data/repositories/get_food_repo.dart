import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/data/datasources/get_food_dp.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/domain/entities/food_search_result.dart';

import '../../../../core/core.dart';
import '../../domain/repositories/get_food_repository.dart';
import '../models/search_food_model.dart';

class GetFoodRepoImpl extends GetFoodRepository {
  final GetFoodDataProvider getFoodDataProvider;

  GetFoodRepoImpl({required this.getFoodDataProvider});
  @override
  Future<Either<Failure, List<FoodSearchResultModel>>> searchFood(
      {required String restaurantId, required String query}) async {
    try {
      final foodSearchResult = await getFoodDataProvider.searchFood(
          restaurantId: restaurantId, query: query);
      return Right(foodSearchResult);
    } catch (exception) {
      return Left(
        mapExceptionToFailure(exception: exception),
      );
    }
  }

  @override
  Future<Either<Failure, List<FoodSearchResult>>> getHighestRatedFoods(
      {required String restaurantId}) async {
    try {
      final foodSearchResult = await getFoodDataProvider.getHighestRatedFoods(
          restaurantId: restaurantId);
      return Right(foodSearchResult);
    } catch (exception) {
      return Left(
        mapExceptionToFailure(exception: exception),
      );
    }
  }
}
