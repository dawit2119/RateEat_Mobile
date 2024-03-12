import 'package:rateeat_mobile/src/features/review/domain/entities/add_restaurant_review_request.dart';

class AddRestaurantReviewRequestModel extends AddRestaurantReviewRequest {
  AddRestaurantReviewRequestModel({
    required super.restaurantId,
    required super.rating,
    super.comment,
    super.images,
    super.videos,
  });
}
