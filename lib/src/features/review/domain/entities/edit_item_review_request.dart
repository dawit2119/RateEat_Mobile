import 'dart:io';

class EditItemReviewRequest {
  final String reviewId;
  final String itemId;
  final double? rating;
  final String? comment;
  final List<File>? images;
  final List<File>? videos;

  EditItemReviewRequest({
    required this.reviewId,
    required this.itemId,
    this.rating,
    this.comment,
    this.images,
    this.videos,
  });

  EditItemReviewRequest copyWith({
    String? reviewId,
    String? itemId,
    double? rating,
    String? comment,
    List<File>? images,
    List<File>? videos,
  }) {
    return EditItemReviewRequest(
      reviewId: reviewId ?? this.reviewId,
      itemId: itemId ?? this.itemId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      videos: videos ?? this.videos,
    );
  }
}
