part of 'add_item_review_bloc.dart';

abstract class AddItemReviewState extends Equatable {
  const AddItemReviewState();
  @override
  List<Object> get props => [];
}

final class AddItemReviewInitial extends AddItemReviewState {}

final class AddItemReviewLoading extends AddItemReviewState {}

final class AddItemReviewSuccess extends AddItemReviewState {}

final class AddItemReviewFailure extends AddItemReviewState {
  final String message;

  const AddItemReviewFailure({required this.message});

  @override
  List<Object> get props => [message];
}
