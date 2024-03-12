part of 'delete_item_review_bloc.dart';

abstract class DeleteItemReviewState extends Equatable {
  const DeleteItemReviewState();

  @override
  List<Object> get props => [];
}

final class DeleteItemReviewInitial extends DeleteItemReviewState {}

final class DeleteItemReviewLoading extends DeleteItemReviewState {}

final class DeleteItemReviewSuccess extends DeleteItemReviewState {
  final String message;

  const DeleteItemReviewSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class DeleteItemReviewFailure extends DeleteItemReviewState {
  final String message;

  const DeleteItemReviewFailure({required this.message});

  @override
  List<Object> get props => [message];
}
