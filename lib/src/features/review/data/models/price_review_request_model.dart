import 'package:rateeat_mobile/src/features/review/domain/entities/price_review_request_model.dart';

class PriceReviewRequestModel extends PriceChangeRequest {
  PriceReviewRequestModel(
      {required super.restaurantId, required super.images, super.description});
}
