part of 'restaurant_popular_reviews_bloc.dart';

abstract class RestaurantPopularReviewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRestaurantPopularReviewsEvent extends RestaurantPopularReviewsEvent {
  final String restaurantId;
  GetRestaurantPopularReviewsEvent({required this.restaurantId});
  @override
  List<Object?> get props => [restaurantId];
}
