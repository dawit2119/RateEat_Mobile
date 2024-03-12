part of 'draft_to_review_bloc.dart';

abstract class DraftToReviewState extends Equatable {
  @override
  List<Object> get props => [];
}

class DraftToReviewInitial extends DraftToReviewState {}

final class DraftToReviewLoading extends DraftToReviewState {}

final class DraftToReviewSuccess extends DraftToReviewState {
  final String message;

  DraftToReviewSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class DraftToReviewFailure extends DraftToReviewState {
  final String message;

  DraftToReviewFailure({required this.message});

  @override
  List<Object> get props => [message];
}
