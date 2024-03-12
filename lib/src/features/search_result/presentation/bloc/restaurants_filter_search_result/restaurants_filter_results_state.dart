import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class RestaurantsFilterSearchResultsState extends Equatable {
  final RestaurantsFilterState selection;
  final String searchQuery;
  final int category;
  final Location? location;
  final bool isFasting;
  final double rating;
  final int maximumPrice;
  const RestaurantsFilterSearchResultsState({
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

class FilterRestaurantsInitial extends RestaurantsFilterSearchResultsState {
  const FilterRestaurantsInitial({
    required super.selection,
    required super.searchQuery,
    required super.category,
    required super.isFasting,
    required super.location,
    required super.maximumPrice,
    required super.rating,
  });
}

class FilterRestaurantsLoading extends RestaurantsFilterSearchResultsState {
  const FilterRestaurantsLoading({
    required super.selection,
    required super.searchQuery,
    required super.isFasting,
    required super.category,
    super.location,
    required super.maximumPrice,
    required super.rating,
  });
}

class FilterRestaurantsSuccess extends RestaurantsFilterSearchResultsState {
  final List<Restaurant> searchFilteredRestaurants;
  final bool hasReachedMax;
  final bool status;

  const FilterRestaurantsSuccess({
    required this.status,
    this.hasReachedMax = false,
    required this.searchFilteredRestaurants,
    required super.selection,
    required super.searchQuery,
    required super.isFasting,
    required super.category,
    required super.location,
    required super.maximumPrice,
    required super.rating,
  });
}

class FilterRestaurantsFailure extends RestaurantsFilterSearchResultsState {
  final String message;

  const FilterRestaurantsFailure({
    required this.message,
    required super.selection,
    required super.category,
    required super.isFasting,
    required super.location,
    required super.maximumPrice,
    required super.rating,
    required super.searchQuery,
  });
}

class FilterRestaurantsNextLoading extends RestaurantsFilterSearchResultsState {
  final List<Restaurant> searchFilteredRestaurants;

  const FilterRestaurantsNextLoading({
    required this.searchFilteredRestaurants,
    required super.selection,
    required super.searchQuery,
    required super.isFasting,
    required super.category,
    super.location,
    required super.maximumPrice,
    required super.rating,
  });
}

enum RestaurantsFilterState { mostPopular, highestRated, closest, priceSorted }
