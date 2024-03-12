import 'package:rateeat_mobile/src/features/review/domain/entities/edit_item_review_request.dart';

class EditItemReviewRequestModel extends EditItemReviewRequest {
  EditItemReviewRequestModel({
    required super.reviewId,
    required super.itemId,
    super.rating,
    super.comment,
    super.images,
    super.videos,
  });
}
