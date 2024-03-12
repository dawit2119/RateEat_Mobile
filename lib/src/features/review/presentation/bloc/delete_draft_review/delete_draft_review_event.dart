part of 'delete_draft_review_bloc.dart';

abstract class DeleteDraftReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DeleteDraftItemReviewRequestEvent extends DeleteDraftReviewEvent {
  final DeleteDraftItemReviewRequestModel deleteDraftItemReviewRequestModel;
  DeleteDraftItemReviewRequestEvent(
      {required this.deleteDraftItemReviewRequestModel});

  @override
  List<Object> get props => [deleteDraftItemReviewRequestModel];
}
