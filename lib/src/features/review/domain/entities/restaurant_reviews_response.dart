import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_review_response.dart';

class RestaurantReviewsResponse {
  final List<RestaurantReviewResponse> reviews;
  final List<int> ratingsCount;
  final double averageRating;
  final int numberOfReviews;

  RestaurantReviewsResponse({
    required this.reviews,
    required this.ratingsCount,
    required this.averageRating,
    required this.numberOfReviews,
  });

  RestaurantReviewsResponse copyWith({
    List<RestaurantReviewResponse>? reviews,
    List<int>? ratingsCount,
    double? averageRating,
    int? numberOfReviews,
  }) {
    return RestaurantReviewsResponse(
      reviews: reviews ?? this.reviews,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      averageRating: averageRating ?? this.averageRating,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
    );
  }
}
