import 'package:equatable/equatable.dart';

class RecommendedItemsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRecommendedItemsEvent extends RecommendedItemsEvent {
  final String itemId;
  GetRecommendedItemsEvent({required this.itemId});
}
