part of 'delete_draft_review_bloc.dart';

abstract class DeleteDraftReviewState extends Equatable {
  @override
  List<Object> get props => [];
}

final class DeleteDraftItemReviewInitial extends DeleteDraftReviewState {}

final class DeleteDraftItemReviewLoading extends DeleteDraftReviewState {}

final class DeleteDraftItemReviewSuccess extends DeleteDraftReviewState {
  final String message;

  DeleteDraftItemReviewSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class DeleteDraftItemReviewFailure extends DeleteDraftReviewState {
  final String message;

  DeleteDraftItemReviewFailure({required this.message});

  @override
  List<Object> get props => [message];
}
