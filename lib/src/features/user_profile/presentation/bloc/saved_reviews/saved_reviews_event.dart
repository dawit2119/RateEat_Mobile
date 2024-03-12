part of 'saved_reviews_bloc.dart';

abstract class SavedReviewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetSavedReviewsEvent extends SavedReviewsEvent {
  final int limit;
  final int page;
  GetSavedReviewsEvent({
    this.limit = 7,
    this.page = 1,
  });

  @override
  List<Object?> get props => [limit, page];

  GetSavedReviewsEvent copyWith({int? limit, int? page}) =>
      GetSavedReviewsEvent(limit: limit ?? this.limit, page: page ?? this.page);
}
