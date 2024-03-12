part of 'add_item_review_bloc.dart';

abstract class AddItemReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddItemReviewRequestEvent extends AddItemReviewEvent {
  final AddItemReviewRequestModel addItemReviewRequest;
  final bool isCandidateItem;
  AddItemReviewRequestEvent({
    required this.addItemReviewRequest,
    this.isCandidateItem = false,
  });
  @override
  List<Object?> get props => [addItemReviewRequest];
}
