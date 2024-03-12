import 'package:rateeat_mobile/src/features/review/data/models/restaurant_review_response_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';

class RestaurantReviewsResponseModel extends RestaurantReviewsResponse {
  RestaurantReviewsResponseModel({
    required super.reviews,
    required super.ratingsCount,
    required super.averageRating,
    required super.numberOfReviews,
  });
  factory RestaurantReviewsResponseModel.fromJson(Map<String, dynamic> json) =>
      RestaurantReviewsResponseModel(
        reviews: json['restaurantReviews']
                ?.map<RestaurantReviewResponseModel>(
                  (review) => RestaurantReviewResponseModel.fromMap(review),
                )
                .toList() ??
            [],
        ratingsCount: json['ratingCount'] != null
            ? getRatingCount(json['ratingCount'])
            : [0, 0, 0, 0, 0],
        averageRating: json['avgRating'] != null
            ? double.parse(
                (json['avgRating'].toDouble() ?? 0.0).toStringAsFixed(2))
            : 0.0,
        numberOfReviews: json['numReviews'] ?? 0,
      );
}

List<int> getRatingCount(Map<String, dynamic>? json) {
  if (json == null) {
    return [0, 0, 0, 0, 0];
  }
  return [
    json['one_star_count'] ?? 0,
    json['two_star_count'] ?? 0,
    json['three_star_count'] ?? 0,
    json['four_star_count'] ?? 0,
    json['five_star_count'] ?? 0,
  ];
}
