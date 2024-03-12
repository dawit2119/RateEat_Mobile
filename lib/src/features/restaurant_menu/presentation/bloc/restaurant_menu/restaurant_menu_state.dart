part of 'restaurant_menu_bloc.dart';

abstract class RestaurantMenuState extends Equatable {
  const RestaurantMenuState();

  @override
  List<Object> get props => [];
}

class RestaurantMenuCategoryItemsFetching extends RestaurantMenuState {}

// class RestaurantMenuItemsFetched extends RestaurantMenuState {
//   final List<RestaurantMenuItem> items;

//   const RestaurantMenuItemsFetched({
//     required this.items,
//   });
// }

class RestaurantMenuCategoryItemsFetchingFailed extends RestaurantMenuState {
  final String message;

  const RestaurantMenuCategoryItemsFetchingFailed({
    required this.message,
  });
}

class RestaurantMenuCategoryItemsNextLoading extends RestaurantMenuState {
  final Menu menu;
  final String categoryId;
  const RestaurantMenuCategoryItemsNextLoading({
    required this.menu,
    required this.categoryId,
  });
}

class RestaurantMenuCategoryItemsFetched extends RestaurantMenuState {
  final Menu menu;
  final String categoryId;
  final bool hasMaxReached;
  final bool isFetchingSuccessful;
  final int page;
  final String query;
  const RestaurantMenuCategoryItemsFetched({
    required this.menu,
    required this.categoryId,
    required this.query,
    this.hasMaxReached = false,
    this.isFetchingSuccessful = true,
    this.page = 1,
  });
}
