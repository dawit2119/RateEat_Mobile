import 'package:rateeat_mobile/src/features/review/domain/entities/item_review_response.dart';

class ItemReviewsResponse {
  final List<int> ratingsCount;
  final List<ItemReviewResponse> reviews;
  final double averageRating;
  final int numberOfReviews;

  ItemReviewsResponse({
    required this.ratingsCount,
    required this.reviews,
    required this.averageRating,
    required this.numberOfReviews,
  });

  ItemReviewsResponse copyWith({
    List<int>? ratingsCount,
    List<ItemReviewResponse>? reviews,
    double? averageRating,
    int? numberOfReviews,
  }) {
    return ItemReviewsResponse(
      ratingsCount: ratingsCount ?? this.ratingsCount,
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
    );
  }
}
