abstract class ItemReviewsCardEvent {}

class ItemReviewsCardFlaggedEvent extends ItemReviewsCardEvent {
  final String id;
  ItemReviewsCardFlaggedEvent({required this.id});
}

class ItemReviewsCardNormalEvent extends ItemReviewsCardEvent {
  final String id;
  ItemReviewsCardNormalEvent({required this.id});
}
