import 'package:rateeat_mobile/src/features/review/data/models/item_review_reponse_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';

class ItemReviewsResponseModel extends ItemReviewsResponse {
  ItemReviewsResponseModel({
    required super.ratingsCount,
    required super.reviews,
    required super.averageRating,
    required super.numberOfReviews,
  });

  factory ItemReviewsResponseModel.fromJson(Map<String, dynamic> json) =>
      ItemReviewsResponseModel(
        reviews: json['itemReviews']
                ?.map<ItemReviewResponseModel>(
                  (review) => ItemReviewResponseModel.fromJson(review),
                )
                .toList() ??
            [],
        ratingsCount: json['ratingCount'] != null
            ? getRatingCount(json['ratingCount'] ?? <String, dynamic>{})
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
