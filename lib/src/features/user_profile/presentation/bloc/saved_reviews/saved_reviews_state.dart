part of 'saved_reviews_bloc.dart';

abstract class SavedReviewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SavedReviewsInitial extends SavedReviewsState {}

class SavedReviewLoading extends SavedReviewsState {}

class SavedReviewLoaded extends SavedReviewsState {
  final List<SavedReviewsResponse> savedReviews;
  final bool hasReachedMax;
  final bool status;
  final bool isLocalData;
  final int page;
  SavedReviewLoaded({
    required this.savedReviews,
    required this.isLocalData,
    required this.page,
    this.hasReachedMax = false,
    this.status = true,
  });
  @override
  List<Object?> get props => [savedReviews, hasReachedMax, status];
}

class SavedNextReviewsLoading extends SavedReviewsState {
  final List<SavedReviewsResponse> savedReviews;
  SavedNextReviewsLoading({
    required this.savedReviews,
  });

  @override
  List<Object?> get props => [savedReviews];
}

class SavedReviewError extends SavedReviewsState {
  final String error;
  SavedReviewError({required this.error});
  @override
  List<Object?> get props => [error];
}
