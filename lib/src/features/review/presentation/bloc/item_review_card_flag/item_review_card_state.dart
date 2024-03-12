abstract class ItemReviewsCardState {
  String get id;
}

class ItemReviewsCardInitial extends ItemReviewsCardState {
  @override
  final String id;
  ItemReviewsCardInitial({required this.id});
}

class ItemReviewsCardFlagged extends ItemReviewsCardState {
  @override
  final String id;
  ItemReviewsCardFlagged({required this.id});
}
