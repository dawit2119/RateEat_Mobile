part of 'simple_review_stepper_bloc.dart';

class SimpleReviewStepperState extends Equatable {
  final SimpleAddReviewStepperModel simpleAddReviewStepperProps;
  const SimpleReviewStepperState({required this.simpleAddReviewStepperProps});

  @override
  List<Object> get props => [simpleAddReviewStepperProps];
}
