part of 'get_restaurant_reviews_bloc.dart';

abstract class GetRestaurantReviewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRestaurantReviewsRequestEvent extends GetRestaurantReviewsEvent {
  final String restaurantId;
  final RestaurantReviewsSortTypesState sortType;
  final int page;
  final int limit;
  GetRestaurantReviewsRequestEvent({
    required this.restaurantId,
    this.sortType = RestaurantReviewsSortTypesState.mostRecent,
    this.page = 1,
    this.limit = 7,
  });
  @override
  List<Object?> get props => [restaurantId];
}

class ResetRestaurantReviewsRequestEvent extends GetRestaurantReviewsEvent {}
