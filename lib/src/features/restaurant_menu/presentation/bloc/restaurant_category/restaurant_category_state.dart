part of 'restaurant_category_bloc.dart';

sealed class RestaurantCategoryState extends Equatable {
  const RestaurantCategoryState();

  @override
  List<Object> get props => [];
}

class RestaurantCategoriesLoading extends RestaurantCategoryState {}

class RestaurantCategoriesLoaded extends RestaurantCategoryState {
  final List<RestaurantCategory> categories;

  const RestaurantCategoriesLoaded({
    required this.categories,
  });

  @override
  List<Object> get props => [categories];
}

class RestaurantCategoriesLoadingFailed extends RestaurantCategoryState {
  final String message;

  const RestaurantCategoriesLoadingFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
