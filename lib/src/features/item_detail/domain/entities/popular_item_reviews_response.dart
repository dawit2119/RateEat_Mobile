import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_review_response.dart';

part 'popular_item_reviews_response.g.dart';

@HiveType(typeId: 38)
class PopularItemReviewsResponse {
  @HiveField(0)
  final List<int> ratingsCount;
  @HiveField(1)
  final List<PopularItemReviewResponse> reviews;
  @HiveField(2)
  final double averageRating;
  @HiveField(3)
  final int numberOfReviews;
  PopularItemReviewsResponse({
    required this.ratingsCount,
    required this.reviews,
    required this.averageRating,
    required this.numberOfReviews,
  });

  PopularItemReviewsResponse copyWith({
    List<int>? ratingsCount,
    List<PopularItemReviewResponse>? reviews,
    double? averageRating,
    int? numberOfReviews,
  }) {
    return PopularItemReviewsResponse(
      ratingsCount: ratingsCount ?? this.ratingsCount,
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
    );
  }
}
