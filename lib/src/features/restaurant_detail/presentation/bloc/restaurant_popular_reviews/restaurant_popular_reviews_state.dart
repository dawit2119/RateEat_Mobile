part of 'restaurant_popular_reviews_bloc.dart';

abstract class RestaurantPopularReviewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularRestaurantReviewsInitial extends RestaurantPopularReviewsState {}

class PopularRestaurantReviewsLoading extends RestaurantPopularReviewsState {}

class PopularRestaurantReviewsLoaded extends RestaurantPopularReviewsState {
  final PopularRestaurantReviewsResponse popularReviews;
  PopularRestaurantReviewsLoaded({required this.popularReviews});
  @override
  List<Object?> get props => [popularReviews];
}

class PopularRestaurantReviewsFailure extends RestaurantPopularReviewsState {
  final String message;
  PopularRestaurantReviewsFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
