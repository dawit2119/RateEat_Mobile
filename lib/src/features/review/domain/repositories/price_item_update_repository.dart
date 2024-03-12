import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';

abstract class ItemPriceReviewRepository {
  Future<Either<Failure, String>> priceReviewRequest(
      {required PriceItemReviewRequestModel priceItemReviewRequestModel});
}
