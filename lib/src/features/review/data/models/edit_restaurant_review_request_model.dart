import 'package:rateeat_mobile/src/features/review/domain/entities/edit_restaurant_review_request.dart';

class EditRestaurantReviewRequestModel extends EditRestaurantReviewRequest {
  EditRestaurantReviewRequestModel({
    required super.reviewId,
    required super.restaurantId,
    super.rating,
    super.comment,
    super.images,
    super.videos,
  });
}
