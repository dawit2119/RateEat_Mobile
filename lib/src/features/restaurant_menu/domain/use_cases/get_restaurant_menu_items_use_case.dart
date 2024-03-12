import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import '../repositories/restaurant_menu_repository.dart';

class GetRestaurantMenuItemsUseCase
    extends UseCase<List<ItemModel>, GetRestaurantItemsParams> {
  final RestaurantMenuRepository restaurantMenuRepository;

  GetRestaurantMenuItemsUseCase({
    required this.restaurantMenuRepository,
  });

  @override
  Future<Either<Failure, List<ItemModel>>> call(
      GetRestaurantItemsParams params) async {
    return await restaurantMenuRepository.getRestaurantMenuItems(
      restaurantId: params.restaurantId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetRestaurantItemsParams extends Equatable {
  final String restaurantId;
  final int page;
  final int limit;
  const GetRestaurantItemsParams({
    required this.restaurantId,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [restaurantId, page, limit];
}
