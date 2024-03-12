import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';

import '../../../../features.dart';

abstract class RestaurantsFilterSearchResultsEvent extends Equatable {
  const RestaurantsFilterSearchResultsEvent();

  @override
  List<Object> get props => [];
}

class GetFilteredRestaurantEvent extends RestaurantsFilterSearchResultsEvent {
  final int category;
  final RestaurantsFilterState selection;
  final bool isFasting;
  final String searchQuery;
  final Location location;
  final double rating;
  final int maximumPrice;
  final int page;
  final int limit;
  final double latitude;
  final double longitude;
  const GetFilteredRestaurantEvent({
    required this.location,
    required this.category,
    required this.isFasting,
    required this.searchQuery,
    required this.selection,
    required this.rating,
    required this.maximumPrice,
    this.page = 1,
    this.limit = 7,
    this.latitude = 0,
    this.longitude = 0,
  });
}
