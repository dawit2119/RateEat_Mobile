part of 'delete_item_review_bloc.dart';

abstract class DeleteItemReviewEvent extends Equatable {
  const DeleteItemReviewEvent();

  @override
  List<Object> get props => [];
}

class DeleteItemReviewRequestEvent extends DeleteItemReviewEvent {
  final DeleteItemReviewRequestModel deleteItemReviewRequestModel;

  const DeleteItemReviewRequestEvent(
      {required this.deleteItemReviewRequestModel});

  @override
  List<Object> get props => [deleteItemReviewRequestModel];
}
