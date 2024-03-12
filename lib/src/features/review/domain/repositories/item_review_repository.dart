import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';

import '../entities/flag_review.dart';

abstract class ItemReviewRepository {
  Future<Either<Failure, ItemReviewsResponse>> getItemReviewsByPopularity(
      {required itemId, required int limit, required int page});
  Future<Either<Failure, ItemReviewsResponse>> getItemReviewsByTime(
      {required itemId, required int limit, required int page});
  Future<Either<Failure, bool>> addItemReview({
    required AddItemReviewRequestModel addItemReviewRequestModel,
    required bool isCandidateItem,
  });
  Future<Either<Failure, String>> editItemReview(
      {required EditItemReviewRequestModel editItemReviewRequestModel});
  Future<Either<Failure, String>> deleteItemReview({
    required DeleteItemReviewRequestModel deleteItemReviewRequestModel,
  });
  Future<Either<Failure, String>> addDraftToReview(
      {required DraftToReviewRequestModel draftToReviewRequestModel});
  Future<Either<Failure, String>> deleteDraftItemReview({
    required DeleteDraftItemReviewRequestModel
        deleteDraftItemReviewRequestModel,
  });
  Future<Either<Failure, String>> flagReview({
    required FlagReview review,
  });
}
