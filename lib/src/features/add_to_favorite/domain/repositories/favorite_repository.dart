import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, bool>> addItemToFavorite({
    required String itemId,
  });
  Future<Either<Failure, bool>> removeItemFromFavorite({
    required String itemId,
  });
  Future<Either<Failure, bool>> addRestaurantToFavorite({
    required String restaurantId,
  });
  Future<Either<Failure, bool>> removeRestaurantFromFavorite({
    required String restaurantId,
  });
}
