import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../entities/food_search_result.dart';

abstract class GetFoodRepository {
  Future<Either<Failure, List<FoodSearchResult>>> searchFood(
      {required String restaurantId, required String query});

  Future<Either<Failure, List<FoodSearchResult>>> getHighestRatedFoods(
      {required String restaurantId});
}
