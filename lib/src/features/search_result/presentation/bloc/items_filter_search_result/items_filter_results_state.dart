import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class ItemsFilterSearchResultsState extends Equatable {
  final ItemsFilterState selection;
  final String searchQuery;
  final int category;
  final Location? location;
  final bool isFasting;
  final double rating;
  final int maximumPrice;
  const ItemsFilterSearchResultsState({
    required this.selection,
    required this.searchQuery,
    required this.category,
    required this.location,
    required this.isFasting,
    required this.rating,
    required this.maximumPrice,
  });

  @override
  List<Object> get props => [];
}

class FilterItemsInitial extends ItemsFilterSearchResultsState {
  const FilterItemsInitial({
    required super.selection,
    required super.searchQuery,
    required super.category,
    required super.isFasting,
    required super.location,
    required super.maximumPrice,
    required super.rating,
  });
}

class FilterItemsLoading extends ItemsFilterSearchResultsState {
  const FilterItemsLoading({
    required super.selection,
    required super.searchQuery,
    required super.isFasting,
    required super.category,
    super.location,
    required super.maximumPrice,
    required super.rating,
  });
}

class FilterItemsNextLoading extends ItemsFilterSearchResultsState {
  final List<ItemModel> searchFilteredItems;

  const FilterItemsNextLoading({
    required this.searchFilteredItems,
    required super.selection,
    required super.searchQuery,
    required super.isFasting,
    required super.category,
    super.location,
    required super.maximumPrice,
    required super.rating,
  });
}

class FilterItemsSuccess extends ItemsFilterSearchResultsState {
  final List<ItemModel> searchFilteredItems;
  final bool hasReachedMax;
  final bool status;

  const FilterItemsSuccess({
    this.hasReachedMax = false,
    required this.status,
    required this.searchFilteredItems,
    required super.selection,
    required super.searchQuery,
    required super.isFasting,
    required super.category,
    required super.maximumPrice,
    required super.rating,
    required super.location,
  });
}

class FilterItemsFailure extends ItemsFilterSearchResultsState {
  final String message;

  const FilterItemsFailure({
    required this.message,
    required super.selection,
    required super.category,
    required super.isFasting,
    required super.maximumPrice,
    required super.rating,
    required super.location,
    required super.searchQuery,
  });
}

enum ItemsFilterState { mostPopular, highestRated, closest, priceSorted }
