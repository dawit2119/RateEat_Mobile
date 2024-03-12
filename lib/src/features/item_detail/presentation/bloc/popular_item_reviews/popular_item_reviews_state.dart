import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_reviews_response.dart';

class PopularItemReviewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularItemReviewsInitial extends PopularItemReviewsState {}

class PopularItemReviewLoading extends PopularItemReviewsState {}

class PopularItemReviewsLoaded extends PopularItemReviewsState {
  final PopularItemReviewsResponse popularReviews;
  final bool isLocal;
  PopularItemReviewsLoaded(
      {required this.popularReviews, required this.isLocal});
  @override
  List<Object?> get props => [popularReviews];
}

class PopularItemReviewsFailure extends PopularItemReviewsState {
  final String message;
  PopularItemReviewsFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
