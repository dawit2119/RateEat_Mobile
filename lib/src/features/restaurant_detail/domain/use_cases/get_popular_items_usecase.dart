import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/entities.dart';

import '../repositories/restaurant__detail_repository.dart';

class GetPopularItemsUseCase
    implements UseCase<List<RestaurantMenuItem>, GetPopularItemsParams> {
  final RestaurantDetailRepository repository;
  GetPopularItemsUseCase({
    required this.repository,
  });
  @override
  Future<Either<Failure, List<RestaurantMenuItem>>> call(
      GetPopularItemsParams params) async {
    return await repository.getPopularItems(
      restaurantId: params.restaurantId,
    );
  }
}

class GetPopularItemsParams extends Equatable {
  final String restaurantId;

  const GetPopularItemsParams({
    required this.restaurantId,
  });

  @override
  List<Object> get props => [restaurantId];
}
