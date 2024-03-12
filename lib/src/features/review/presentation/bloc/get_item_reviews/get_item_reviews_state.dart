part of 'get_item_reviews_bloc.dart';

enum ItemReviewsSortTypesState { mostRecent, mostPopular }

abstract class GetItemReviewsState extends Equatable {
  final ItemReviewsSortTypesState sortType;
  const GetItemReviewsState({required this.sortType});

  @override
  List<Object?> get props => [];
}

final class GetItemReviewsInitial extends GetItemReviewsState {
  const GetItemReviewsInitial({required super.sortType});
}

final class GetItemReviewsLoading extends GetItemReviewsState {
  const GetItemReviewsLoading({required super.sortType});
}

final class GetItemReviewsLoaded extends GetItemReviewsState {
  final ItemReviewsResponse reviews;
  final bool hasReachedMax;
  final bool status;
  const GetItemReviewsLoaded({
    this.status = true,
    required this.reviews,
    required super.sortType,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [status, reviews, hasReachedMax, sortType];
}

final class GetItemReviewsNextLoading extends GetItemReviewsState {
  final ItemReviewsResponse reviews;

  const GetItemReviewsNextLoading({
    required super.sortType,
    required this.reviews,
  });
}

final class GetItemReviewsFailure extends GetItemReviewsState {
  final String message;
  const GetItemReviewsFailure({required this.message, required super.sortType});
  @override
  List<Object?> get props => [message];
}
