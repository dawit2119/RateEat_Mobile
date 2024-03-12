import 'package:equatable/equatable.dart';

import '../../../../features.dart';
import './items_filter_results_state.dart';

abstract class ItemsFilterSearchResultsEvent extends Equatable {
  const ItemsFilterSearchResultsEvent();

  @override
  List<Object> get props => [];
}

class GetFilteredItemsEvent extends ItemsFilterSearchResultsEvent {
  final ItemsFilterState selection;
  final bool isFasting;
  final String searchQuery;
  final Location location;
  final double rating;
  final int maximumPrice;
  final int page;
  final int limit;
  final double latitude;
  final double longitude;
  const GetFilteredItemsEvent({
    required this.location,
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

class ResetItemsFilterSearchResultsEvent
    extends ItemsFilterSearchResultsEvent {}
