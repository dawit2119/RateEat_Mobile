part of 'delete_restaurant_review_bloc.dart';

abstract class DeleteRestaurantReviewState extends Equatable {
  const DeleteRestaurantReviewState();

  @override
  List<Object> get props => [];
}

final class DeleteRestaurantReviewInitial extends DeleteRestaurantReviewState {}

final class DeleteRestaurantReviewLoading extends DeleteRestaurantReviewState {}

final class DeleteRestaurantReviewSuccess extends DeleteRestaurantReviewState {
  final String message;

  const DeleteRestaurantReviewSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class DeleteRestaurantReviewFailure extends DeleteRestaurantReviewState {
  final String message;

  const DeleteRestaurantReviewFailure({required this.message});

  @override
  List<Object> get props => [message];
}
