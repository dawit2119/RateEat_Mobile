part of 'add_review_to_draft_bloc.dart';

abstract class AddReviewToDraftState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AddReviewToDraftInitial extends AddReviewToDraftState {}

final class AddReviewToDraftLoading extends AddReviewToDraftState {}

final class AddReviewToDraftSuccess extends AddReviewToDraftState {
  final String message;

  AddReviewToDraftSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class AddReviewToDraftFailure extends AddReviewToDraftState {
  final String message;

  AddReviewToDraftFailure({required this.message});

  @override
  List<Object> get props => [message];
}
