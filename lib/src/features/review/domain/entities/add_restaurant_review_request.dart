import 'dart:io';

class AddRestaurantReviewRequest {
  final String restaurantId;
  final double rating;
  final String? comment;
  final List<File>? images;
  final List<File>? videos;

  AddRestaurantReviewRequest({
    required this.restaurantId,
    required this.rating,
    this.comment,
    this.images,
    this.videos,
  });

  AddRestaurantReviewRequest copyWith({
    String? restaurantId,
    double? rating,
    String? comment,
    List<File>? images,
    List<File>? videos,
  }) {
    return AddRestaurantReviewRequest(
      restaurantId: restaurantId ?? this.restaurantId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      videos: videos ?? this.videos,
    );
  }
}
