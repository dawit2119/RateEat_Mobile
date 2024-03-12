part of 'restaurant_category_bloc.dart';

sealed class RestaurantCategoryEvent extends Equatable {
  const RestaurantCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetRestaurantCategoriesEvent extends RestaurantCategoryEvent {
  final String restaurantId;
  const GetRestaurantCategoriesEvent({required this.restaurantId});

  @override
  List<Object> get props => [restaurantId];
}
