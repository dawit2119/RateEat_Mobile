class DeleteItemReviewRequest {
  final String itemId;
  final String reviewId;

  DeleteItemReviewRequest({
    required this.itemId,
    required this.reviewId,
  });

  DeleteItemReviewRequest copyWith({
    String? itemId,
    String? reviewId,
  }) {
    return DeleteItemReviewRequest(
      itemId: itemId ?? this.itemId,
      reviewId: reviewId ?? this.reviewId,
    );
  }
}
