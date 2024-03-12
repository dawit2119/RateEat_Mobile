import 'package:equatable/equatable.dart';

class FlagReview extends Equatable {
  final String reportType;
  final String reviewId;
  final String? text;
  final String userId;
  const FlagReview({
    required this.reportType,
    required this.reviewId,
    this.text,
    required this.userId,
  });
  @override
  List<Object?> get props => [
        reportType,
        reviewId,
        text,
        userId,
      ];
  Map<String, dynamic> toJson() {
    return {
      "report_type": reportType,
      "review_id": reviewId,
      "text": text,
      "user_id": userId,
    };
  }
}
