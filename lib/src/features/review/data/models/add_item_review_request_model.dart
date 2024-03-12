import 'package:rateeat_mobile/src/features/review/domain/entities/add_item_review_request.dart';

class AddItemReviewRequestModel extends AddItemReviewRequest {
  AddItemReviewRequestModel({
    required super.itemId,
    required super.rating,
    super.comment,
    super.images,
    super.videos,
  });
}
