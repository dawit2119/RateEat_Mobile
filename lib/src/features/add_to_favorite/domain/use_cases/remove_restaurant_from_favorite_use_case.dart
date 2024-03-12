import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/repositories/favorite_repository.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/add_restaurant_to_favorite_use_case.dart';

class RemoveRestaurantFromFavoriteUseCase
    extends UseCase<bool, RestaurantFavoriteParams> {
  final FavoriteRepository repository;

  RemoveRestaurantFromFavoriteUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(RestaurantFavoriteParams params) async {
    return await repository.removeRestaurantFromFavorite(
        restaurantId: params.restaurantId);
  }
}
