part of 'flag_review_bloc.dart';

abstract class FlagReviewEvent extends Equatable {}

class Flag extends FlagReviewEvent {
  final FlagReview review;

  Flag({
    required this.review,
  });

  @override
  List<Object?> get props => [review];
}
