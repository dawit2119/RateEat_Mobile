part of 'get_item_reviews_bloc.dart';

abstract class GetItemReviewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetItemReviewsRequestEvent extends GetItemReviewsEvent {
  final String itemId;
  final int page;
  final int limit;
  final ItemReviewsSortTypesState sortType;

  GetItemReviewsRequestEvent({
    required this.itemId,
    this.page = 1,
    this.limit = 7,
    this.sortType = ItemReviewsSortTypesState.mostRecent,
  });
  @override
  List<Object?> get props => [itemId];
}

class ResetGetItemReviewsEvent extends GetItemReviewsEvent {}
