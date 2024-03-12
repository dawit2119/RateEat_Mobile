part of 'edit_restaurant_review_bloc.dart';

abstract class EditRestaurantReviewState extends Equatable {
  const EditRestaurantReviewState();

  @override
  List<Object> get props => [];
}

final class EditRestaurantReviewInitial extends EditRestaurantReviewState {}

final class EditRestaurantReviewLoading extends EditRestaurantReviewState {}

final class EditRestaurantReviewSuccess extends EditRestaurantReviewState {
  final String message;

  const EditRestaurantReviewSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class EditRestaurantReviewFailure extends EditRestaurantReviewState {
  final String message;

  const EditRestaurantReviewFailure({required this.message});

  @override
  List<Object> get props => [message];
}
