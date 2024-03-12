import './restaurant_review_model.dart';

class RestaurantReviewResult {
  final List<RestaurantReviewModel> reviews;
  final List<int> ratingsCount;

  RestaurantReviewResult({
    required this.reviews,
    required this.ratingsCount,
  });
  factory RestaurantReviewResult.fromJson(Map<String, dynamic> json) =>
      RestaurantReviewResult(
        reviews: json['restaurantReviews']
            .map<RestaurantReviewModel>(
              (review) => RestaurantReviewModel.fromMap(review),
            )
            .toList(),
        ratingsCount: json['ratingcount'] != null
            ? getRatingCount(json['ratingcount'])
            : [0, 0, 0, 0, 0],
      );
}

List<int> getRatingCount(Map<String, dynamic> json) => [
      json['one_star_count'] ?? 0,
      json['two_star_count'] ?? 0,
      json['three_star_count'] ?? 0,
      json['four_star_count'] ?? 0,
      json['five_star_count'] ?? 0,
    ];
