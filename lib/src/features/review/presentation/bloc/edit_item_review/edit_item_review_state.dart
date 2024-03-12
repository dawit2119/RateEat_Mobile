part of 'edit_item_review_bloc.dart';

abstract class EditItemReviewState extends Equatable {
  const EditItemReviewState();

  @override
  List<Object> get props => [];
}

final class EditItemReviewInitial extends EditItemReviewState {}

final class EditItemReviewLoading extends EditItemReviewState {}

final class EditItemReviewSuccess extends EditItemReviewState {
  final String message;

  const EditItemReviewSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class EditItemReviewFailure extends EditItemReviewState {
  final String message;

  const EditItemReviewFailure({required this.message});

  @override
  List<Object> get props => [message];
}
