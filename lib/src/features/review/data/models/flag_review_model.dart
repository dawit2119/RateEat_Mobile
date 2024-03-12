import '../../domain/entities/flag_review.dart';

class FlagReviewModel extends FlagReview {
  const FlagReviewModel({
    required super.reportType,
    required super.reviewId,
    required super.userId,
    super.text,
  });

  factory FlagReviewModel.fromJson(Map<String, dynamic> json) =>
      FlagReviewModel(
        reportType: json["report_type"],
        reviewId: json['review_id'],
        userId: json['user_id'],
        text: json['text'],
      );
}
