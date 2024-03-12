import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';

class PriceReviewEvent extends Equatable {
  const PriceReviewEvent();
  @override
  List<Object?> get props => [];
}

class PriceChangeRequestEvent extends PriceReviewEvent {
  final PriceReviewRequestModel priceReviewRequestModel;
  const PriceChangeRequestEvent({required this.priceReviewRequestModel});
  @override
  List<Object?> get props => [priceReviewRequestModel];
}
