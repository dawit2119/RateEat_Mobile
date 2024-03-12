import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';

abstract class PriceReviewRepository {
  Future<Either<Failure, String>> priceReviewRequest(
      {required PriceReviewRequestModel priceReviewRequestModel});
}
