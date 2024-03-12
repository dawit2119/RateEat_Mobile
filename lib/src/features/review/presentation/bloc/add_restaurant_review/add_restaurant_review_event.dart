part of 'add_restaurant_review_bloc.dart';

abstract class AddRestaurantReviewEvent extends Equatable {
  const AddRestaurantReviewEvent();
  @override
  List<Object?> get props => [];
}

class AddRestaurantReviewRequestEvent extends AddRestaurantReviewEvent {
  final AddRestaurantReviewRequestModel addRestaurantReviewRequest;

  const AddRestaurantReviewRequestEvent({
    required this.addRestaurantReviewRequest,
  });
}
