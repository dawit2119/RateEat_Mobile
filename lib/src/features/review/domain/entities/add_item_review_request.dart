import 'dart:io';

class AddItemReviewRequest {
  final String itemId;
  final double rating;
  final String? comment;
  final List<File>? images;
  final List<File>? videos;

  AddItemReviewRequest({
    required this.itemId,
    required this.rating,
    this.comment,
    this.images,
    this.videos,
  });

  AddItemReviewRequest copyWith({
    String? itemId,
    double? rating,
    String? comment,
    List<File>? images,
    List<File>? videos,
  }) {
    return AddItemReviewRequest(
      itemId: itemId ?? this.itemId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      videos: videos ?? this.videos,
    );
  }
}
