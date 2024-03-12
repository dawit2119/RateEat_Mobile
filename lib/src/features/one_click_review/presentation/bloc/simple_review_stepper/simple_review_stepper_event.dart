part of 'simple_review_stepper_bloc.dart';

abstract class SimpleReviewStepperEvent extends Equatable {
  const SimpleReviewStepperEvent();

  @override
  List<Object> get props => [];
}

class SimpleReviewStepperUpdate extends SimpleReviewStepperEvent {
  final List<XFile>? images;
  final List<XFile>? videos;
  final NearByItemResponse? item;
  final NearByRestaurantResponse? restaurant;

  const SimpleReviewStepperUpdate({
    this.restaurant,
    this.item,
    this.images,
    this.videos,
  });
}
