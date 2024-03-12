part of 'add_restaurant_review_bloc.dart';

abstract class AddRestaurantReviewState extends Equatable {
  const AddRestaurantReviewState();
  @override
  List<Object> get props => [];
}

final class AddRestaurantReviewInitial extends AddRestaurantReviewState {}

final class AddRestaurantReviewLoading extends AddRestaurantReviewState {}

final class AddRestaurantReviewSuccess extends AddRestaurantReviewState {
  final String message;

  const AddRestaurantReviewSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class AddRestaurantReviewFailure extends AddRestaurantReviewState {
  final String message;

  const AddRestaurantReviewFailure({required this.message});

  @override
  List<Object> get props => [message];
}
