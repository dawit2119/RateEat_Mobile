part of 'edit_item_review_bloc.dart';

abstract class EditItemReviewEvent extends Equatable {
  const EditItemReviewEvent();

  @override
  List<Object?> get props => [];
}

class EditItemReviewRequestEvent extends EditItemReviewEvent {
  final EditItemReviewRequestModel editItemReviewRequest;

  const EditItemReviewRequestEvent({
    required this.editItemReviewRequest,
  });

  @override
  List<Object?> get props => [editItemReviewRequest];
}
