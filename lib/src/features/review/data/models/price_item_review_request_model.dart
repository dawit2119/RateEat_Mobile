import 'package:rateeat_mobile/src/features/review/domain/entities/item_price_review_request.dart';

class PriceItemReviewRequestModel extends ItemPriceChangeRequest {
  PriceItemReviewRequestModel(
      {required super.itemId, required super.price, super.description});
}
