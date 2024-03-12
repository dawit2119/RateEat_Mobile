import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/repositories/restaurant__detail_repository.dart';

class GetRestaurantItemsUseCase
    extends UseCase<List<ItemModel>, GetRestaurantItemsParams> {
  final RestaurantDetailRepository repository;

  GetRestaurantItemsUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<ItemModel>>> call(
      GetRestaurantItemsParams params) async {
    return await repository.getRestaurantItems(
        limit: params.limit,
        page: params.page,
        restaurantId: params.restaurantId);
  }
}

class GetRestaurantItemsParams extends Equatable {
  final int page;
  final int limit;
  final String restaurantId;

  const GetRestaurantItemsParams({
    required this.page,
    required this.limit,
    required this.restaurantId,
  });

  @override
  List<Object?> get props => [page, limit, restaurantId];
}
