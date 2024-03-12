part of 'draft_to_review_bloc.dart';

abstract class DraftToReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendDraftToReviewEvent extends DraftToReviewEvent {
  final DraftToReviewRequestModel draftToReviewRequest;
  SendDraftToReviewEvent({
    required this.draftToReviewRequest,
  });
  @override
  List<Object?> get props => [draftToReviewRequest];
}
