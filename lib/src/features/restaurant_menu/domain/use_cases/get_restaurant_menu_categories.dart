import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../entities/restaurant_category.dart';
import '../repositories/restaurant_menu_repository.dart';

class GetRestaurantMenuCategories
    extends UseCase<List<RestaurantCategory>, String> {
  final RestaurantMenuRepository restaurantMenuRepository;

  GetRestaurantMenuCategories({
    required this.restaurantMenuRepository,
  });
  @override
  Future<Either<Failure, List<RestaurantCategory>>> call(String params) async {
    return await restaurantMenuRepository.getRestaurantMenuCategories(
      restaurantId: params,
    );
  }
}
