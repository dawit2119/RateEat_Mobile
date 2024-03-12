import './item_review_model.dart';

class ItemReviewResult {
  final List<int> ratingsCount;
  final List<ItemReviewModel> reviews;
  ItemReviewResult({
    required this.ratingsCount,
    required this.reviews,
  });

  factory ItemReviewResult.fromJson(Map<String, dynamic> json) =>
      ItemReviewResult(
        reviews: json['itemReviews']
            .map<ItemReviewModel>(
              (review) => ItemReviewModel.fromJson(review),
            )
            .toList(),
        ratingsCount: json['ratingCount'] != null
            ? getRatingCount(json['ratingCount'])
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
