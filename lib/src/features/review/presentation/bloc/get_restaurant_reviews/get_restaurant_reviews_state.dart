part of 'get_restaurant_reviews_bloc.dart';

enum RestaurantReviewsSortTypesState { mostRecent, mostPopular }

abstract class GetRestaurantReviewsState extends Equatable {
  final RestaurantReviewsSortTypesState sortType;
  const GetRestaurantReviewsState({required this.sortType});
  @override
  List<Object?> get props => [];
}

final class GetRestaurantReviewsInitial extends GetRestaurantReviewsState {
  const GetRestaurantReviewsInitial({required super.sortType});
}

final class GetRestaurantReviewsLoading extends GetRestaurantReviewsState {
  const GetRestaurantReviewsLoading({required super.sortType});
}

final class GetRestaurantReviewsLoaded extends GetRestaurantReviewsState {
  final bool status;
  final bool hasReachedMax;
  final RestaurantReviewsResponse reviews;
  const GetRestaurantReviewsLoaded({
    this.status = true,
    required this.reviews,
    this.hasReachedMax = false,
    required super.sortType,
  });

  @override
  List<Object?> get props => [status, reviews, hasReachedMax];
}

final class GetRestaurantReviewsNextLoading extends GetRestaurantReviewsState {
  final RestaurantReviewsResponse reviews;

  const GetRestaurantReviewsNextLoading({
    required this.reviews,
    required super.sortType,
  });
}

final class GetRestaurantReviewsFailure extends GetRestaurantReviewsState {
  final String message;
  const GetRestaurantReviewsFailure(
      {required this.message, required super.sortType});
  @override
  List<Object?> get props => [message];
}
