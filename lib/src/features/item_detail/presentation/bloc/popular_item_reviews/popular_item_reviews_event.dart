import 'package:equatable/equatable.dart';

class PopularItemReviewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPopularItemReviewsEvent extends PopularItemReviewsEvent {
  final String itemId;
  GetPopularItemReviewsEvent({required this.itemId});
  @override
  List<Object?> get props => [itemId];
}
