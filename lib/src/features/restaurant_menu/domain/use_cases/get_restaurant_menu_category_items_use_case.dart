import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../entities/menu.dart';
import '../repositories/restaurant_menu_repository.dart';

class GetRestaurantMenuCategoryItemsUseCase
    extends UseCase<Menu, GetRestaurantMenuCategoryItemsParams> {
  final RestaurantMenuRepository restaurantMenuRepository;

  GetRestaurantMenuCategoryItemsUseCase({
    required this.restaurantMenuRepository,
  });

  @override
  Future<Either<Failure, Menu>> call(
      GetRestaurantMenuCategoryItemsParams params) async {
    return await restaurantMenuRepository.getRestaurantMenuCategoryItems(
      restaurantId: params.restaurantId,
      categoryName: params.categoryId,
      page: params.page,
      limit: params.limit,
      query: params.query,
      sortBy: params.sortBy,
    );
  }
}

class GetRestaurantMenuCategoryItemsParams extends Equatable {
  final String restaurantId;
  final String categoryId;
  final int page;
  final int limit;
  final String query;
  final String sortBy;
  const GetRestaurantMenuCategoryItemsParams({
    required this.restaurantId,
    required this.categoryId,
    required this.page,
    required this.limit,
    required this.query,
    required this.sortBy,
  });

  @override
  List<Object> get props =>
      [restaurantId, categoryId, page, limit, query, sortBy];
}
