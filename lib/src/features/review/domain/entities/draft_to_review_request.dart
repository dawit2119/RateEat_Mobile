class DraftToReviewRequest {
  final String draftItemReviewId;
  final String itemId;
  final double? rating;
  final String? comment;
  final List<String>? images;
  final List<String>? videos;

  DraftToReviewRequest({
    required this.draftItemReviewId,
    required this.itemId,
    this.rating,
    this.comment,
    this.images,
    this.videos,
  });

  DraftToReviewRequest copyWith({
    String? draftItemReviewId,
    String? itemId,
    double? rating,
    String? comment,
    List<String>? images,
    List<String>? videos,
  }) {
    return DraftToReviewRequest(
      draftItemReviewId: draftItemReviewId ?? this.draftItemReviewId,
      itemId: itemId ?? this.itemId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      videos: videos ?? this.videos,
    );
  }
}
