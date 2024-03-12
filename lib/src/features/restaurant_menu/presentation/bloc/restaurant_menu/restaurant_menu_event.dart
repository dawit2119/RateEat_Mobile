part of 'restaurant_menu_bloc.dart';

abstract class RestaurantMenuEvent extends Equatable {
  const RestaurantMenuEvent();
  @override
  List<Object> get props => [];
}

class GetRestaurantMenuItems extends RestaurantMenuEvent {
  final String restaurantId;
  final int page;
  final int limit;
  const GetRestaurantMenuItems({
    required this.restaurantId,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [restaurantId];
}

class GetRestaurantMenuCategoryItems extends RestaurantMenuEvent {
  final String restaurantId;
  final String categoryId;
  final int page;
  final int limit;
  final String query;
  final String sortBy;
  const GetRestaurantMenuCategoryItems({
    required this.restaurantId,
    required this.categoryId,
    required this.page,
    required this.limit,
    this.query = "",
    this.sortBy = "ratingDesc",
  });
  @override
  List<Object> get props => [
        restaurantId,
        categoryId,
        page,
        limit,
      ];
}
