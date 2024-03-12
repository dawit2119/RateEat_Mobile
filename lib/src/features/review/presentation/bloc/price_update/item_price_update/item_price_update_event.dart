import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';

class ItemPriceReviewEvent extends Equatable {
  const ItemPriceReviewEvent();
  @override
  List<Object?> get props => [];
}

class ItemPriceChangeRequestEvent extends ItemPriceReviewEvent {
  final PriceItemReviewRequestModel priceItemReviewRequestModel;
  const ItemPriceChangeRequestEvent(
      {required this.priceItemReviewRequestModel});
  @override
  List<Object?> get props => [priceItemReviewRequestModel];
}
