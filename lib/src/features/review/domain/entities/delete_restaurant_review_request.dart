class DeleteRestaurantReviewRequest {
  final String restaurantId;
  final String reviewId;

  DeleteRestaurantReviewRequest({
    required this.restaurantId,
    required this.reviewId,
  });

  DeleteRestaurantReviewRequest copyWith({
    String? restaurantId,
    String? reviewId,
  }) {
    return DeleteRestaurantReviewRequest(
      restaurantId: restaurantId ?? this.restaurantId,
      reviewId: reviewId ?? this.reviewId,
    );
  }
}
