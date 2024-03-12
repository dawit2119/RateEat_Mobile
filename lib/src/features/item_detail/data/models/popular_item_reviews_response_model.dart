import 'package:rateeat_mobile/src/features/item_detail/data/models/popular_item_review_response_model.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_reviews_response.dart';

class PopularItemReviewsResponseModel extends PopularItemReviewsResponse {
  PopularItemReviewsResponseModel({
    required super.ratingsCount,
    required super.reviews,
    required super.averageRating,
    required super.numberOfReviews,
  });

  factory PopularItemReviewsResponseModel.fromJson(Map<String, dynamic> json) =>
      PopularItemReviewsResponseModel(
        reviews: json['itemReviews']
            .map<PopularItemReviewResponseModel>(
              (review) => PopularItemReviewResponseModel.fromJson(review),
            )
            .toList(),
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

List<int> getRatingCount(Map<String, dynamic> json) => [
      json['one_star_count'] ?? 0,
      json['two_star_count'] ?? 0,
      json['three_star_count'] ?? 0,
      json['four_star_count'] ?? 0,
      json['five_star_count'] ?? 0,
    ];
