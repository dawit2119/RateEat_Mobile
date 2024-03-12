import 'package:rateeat_mobile/src/features/review/domain/entities/delete_item_review_request.dart';

class DeleteItemReviewRequestModel extends DeleteItemReviewRequest {
  DeleteItemReviewRequestModel({
    required super.reviewId,
    required super.itemId,
  });

  @override
  DeleteItemReviewRequestModel copyWith({
    String? itemId,
    String? reviewId,
  }) {
    return DeleteItemReviewRequestModel(
      itemId: itemId ?? this.itemId,
      reviewId: reviewId ?? this.reviewId,
    );
  }
}
