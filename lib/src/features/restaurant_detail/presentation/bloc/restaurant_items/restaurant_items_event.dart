part of 'restaurant_items_bloc.dart';

abstract class RestaurantItemsEvent extends Equatable {}

class GetRestaurantItems extends RestaurantItemsEvent {
  final int page;
  final int limit;
  final String restaurantId;
  GetRestaurantItems(
      {required this.page, required this.limit, required this.restaurantId});

  @override
  List<Object> get props => [page];
}

class GetRestaurantPopularItems extends RestaurantItemsEvent {
  final String restaurantId;
  GetRestaurantPopularItems({
    required this.restaurantId,
  });

  @override
  List<Object?> get props => [restaurantId];
}
