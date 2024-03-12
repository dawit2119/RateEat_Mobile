import 'package:rateeat_mobile/src/features/review/domain/entities/draft_to_review_request.dart';

class DraftToReviewRequestModel extends DraftToReviewRequest {
  DraftToReviewRequestModel({
    required super.draftItemReviewId,
    required super.itemId,
    super.rating,
    super.comment,
    super.images,
    super.videos,
  });
}
