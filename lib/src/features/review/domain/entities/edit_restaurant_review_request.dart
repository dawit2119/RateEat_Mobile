import 'dart:io';

class EditRestaurantReviewRequest {
  final String restaurantId;
  final String reviewId;
  final double? rating;
  final String? comment;
  final List<File>? images;
  final List<File>? videos;

  EditRestaurantReviewRequest({
    required this.restaurantId,
    required this.reviewId,
    this.rating,
    this.comment,
    this.images,
    this.videos,
  });

  EditRestaurantReviewRequest copyWith({
    String? restaurantId,
    String? reviewId,
    double? rating,
    String? comment,
    List<File>? images,
    List<File>? videos,
  }) {
    return EditRestaurantReviewRequest(
      restaurantId: restaurantId ?? this.restaurantId,
      reviewId: reviewId ?? this.reviewId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      videos: videos ?? this.videos,
    );
  }
}
