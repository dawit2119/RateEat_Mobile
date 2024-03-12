class DeleteDraftItemReviewRequest {
  final String itemId;
  final String draftItemReviewId;

  DeleteDraftItemReviewRequest({
    required this.itemId,
    required this.draftItemReviewId,
  });

  DeleteDraftItemReviewRequest copyWith({
    String? itemId,
    String? draftItemReviewId,
  }) {
    return DeleteDraftItemReviewRequest(
      itemId: itemId ?? this.itemId,
      draftItemReviewId: draftItemReviewId ?? this.draftItemReviewId,
    );
  }
}
