import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/repositories/favorite_repository.dart';

class AddRestaurantToFavoriteUseCase
    extends UseCase<bool, RestaurantFavoriteParams> {
  final FavoriteRepository repository;

  AddRestaurantToFavoriteUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(RestaurantFavoriteParams params) async {
    return await repository.addRestaurantToFavorite(
        restaurantId: params.restaurantId);
  }
}

class RestaurantFavoriteParams extends Equatable {
  final String restaurantId;
  const RestaurantFavoriteParams({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}
