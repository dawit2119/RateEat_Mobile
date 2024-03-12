import 'package:equatable/equatable.dart';

class GetRestaurantItemsEvent extends Equatable {
  final String restaurantId;

  const GetRestaurantItemsEvent({required this.restaurantId});

  @override
  List<Object> get props => [restaurantId];
}

class SearchFoodEvent extends GetRestaurantItemsEvent {
  final String query;

  const SearchFoodEvent({required super.restaurantId, required this.query});

  @override
  List<Object> get props => [query, restaurantId];
}

class GetHighestedRatedRestaurantItems extends GetRestaurantItemsEvent {
  const GetHighestedRatedRestaurantItems({required super.restaurantId});
}
