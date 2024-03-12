part of 'add_review_to_draft_bloc.dart';

abstract class AddReviewToDraftEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddDraftRequestEvent extends AddReviewToDraftEvent {
  final DraftReviewRequestModel draftReviewRequestModel;
  AddDraftRequestEvent({
    required this.draftReviewRequestModel,
  });
  @override
  List<Object?> get props => [draftReviewRequestModel];
}
