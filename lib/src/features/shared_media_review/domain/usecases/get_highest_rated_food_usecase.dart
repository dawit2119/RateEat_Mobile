import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../entities/food_search_result.dart';
import '../repositories/get_food_repository.dart';

class GetHighestRatedFoodUsecase
    extends UseCase<List<FoodSearchResult>, String> {
  final GetFoodRepository getFoodRepository;

  GetHighestRatedFoodUsecase({required this.getFoodRepository});

  @override
  Future<Either<Failure, List<FoodSearchResult>>> call(params) async {
    return getFoodRepository.getHighestRatedFoods(restaurantId: params);
  }
}
