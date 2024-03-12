import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/draft_review_request.dart';

class DraftReviewRequestModel extends DraftReviewRequest {
  DraftReviewRequestModel({
    required super.itemId,
    required super.restaurantId,
    super.images,
    super.videos,
  });
}
