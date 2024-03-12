import 'package:rateeat_mobile/src/features/review/domain/entities/delete_draft_item_review_request.dart';

class DeleteDraftItemReviewRequestModel extends DeleteDraftItemReviewRequest {
  DeleteDraftItemReviewRequestModel({
    required super.draftItemReviewId,
    required super.itemId,
  });

  @override
  DeleteDraftItemReviewRequestModel copyWith({
    String? itemId,
    String? draftItemReviewId,
  }) {
    return DeleteDraftItemReviewRequestModel(
      itemId: itemId ?? this.itemId,
      draftItemReviewId: draftItemReviewId ?? this.draftItemReviewId,
    );
  }
}
