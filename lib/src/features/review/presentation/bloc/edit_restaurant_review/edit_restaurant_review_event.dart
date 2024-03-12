part of 'edit_restaurant_review_bloc.dart';

abstract class EditRestaurantReviewEvent extends Equatable {
  const EditRestaurantReviewEvent();

  @override
  List<Object?> get props => [];
}

class EditRestaurantReviewRequestEvent extends EditRestaurantReviewEvent {
  final EditRestaurantReviewRequestModel editRestaurantReviewRequest;

  const EditRestaurantReviewRequestEvent({
    required this.editRestaurantReviewRequest,
  });

  @override
  List<Object?> get props => [editRestaurantReviewRequest];
}
