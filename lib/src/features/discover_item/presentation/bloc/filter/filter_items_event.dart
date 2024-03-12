import 'package:equatable/equatable.dart';

class FilterItemsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetFilteredItemsEvent extends FilterItemsEvent {
  final String restaurantId;
  final String maxPrice;

  final bool fasting;
  final String sortingQuery;
  final String? categoryId;
  final int page;
  final int limit;
  final String searchQuery;

  GetFilteredItemsEvent({
    required this.restaurantId,
    required this.maxPrice,
    required this.fasting,
    required this.sortingQuery,
    required this.searchQuery,
    this.categoryId,
    this.page = 1,
    this.limit = 10,
  });
}

class GetSortedItemsEvent extends FilterItemsEvent {
  final String restaurantId;
  final String sortingQuery;
  GetSortedItemsEvent({required this.restaurantId, required this.sortingQuery});
}

class ResetFilterItemsEvent extends FilterItemsEvent {}
