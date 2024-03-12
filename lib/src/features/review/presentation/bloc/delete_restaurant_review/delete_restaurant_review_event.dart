part of 'delete_restaurant_review_bloc.dart';

abstract class DeleteRestaurantReviewEvent extends Equatable {
  const DeleteRestaurantReviewEvent();

  @override
  List<Object> get props => [];
}

class DeleteRestaurantReviewRequestEvent extends DeleteRestaurantReviewEvent {
  final DeleteRestaurantReviewRequestModel deleteRestaurantReviewRequestModel;

  const DeleteRestaurantReviewRequestEvent(
      {required this.deleteRestaurantReviewRequestModel});

  @override
  List<Object> get props => [deleteRestaurantReviewRequestModel];
}
