import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../entities/food_search_result.dart';
import '../repositories/get_food_repository.dart';

class SearchFoodUseCase
    extends UseCase<List<FoodSearchResult>, SearchFoodParams> {
  final GetFoodRepository getFoodRepository;

  SearchFoodUseCase({required this.getFoodRepository});

  @override
  Future<Either<Failure, List<FoodSearchResult>>> call(params) async {
    return getFoodRepository.searchFood(
        restaurantId: params.restaurantId, query: params.query);
  }
}

class SearchFoodParams {
  final String restaurantId;
  final String query;

  SearchFoodParams({
    required this.restaurantId,
    required this.query,
  });
}
