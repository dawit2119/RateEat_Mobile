import 'package:rateeat_mobile/src/features/review/domain/entities/delete_restaurant_review_request.dart';

class DeleteRestaurantReviewRequestModel extends DeleteRestaurantReviewRequest {
  DeleteRestaurantReviewRequestModel({
    required super.restaurantId,
    required super.reviewId,
  });

  @override
  DeleteRestaurantReviewRequestModel copyWith({
    String? restaurantId,
    String? reviewId,
  }) {
    return DeleteRestaurantReviewRequestModel(
      restaurantId: restaurantId ?? this.restaurantId,
      reviewId: reviewId ?? this.reviewId,
    );
  }
}
