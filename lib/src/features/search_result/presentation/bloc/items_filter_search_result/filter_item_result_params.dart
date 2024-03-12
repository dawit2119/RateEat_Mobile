import '../../../../discover/discover.dart';
import './items_filter_results_state.dart';

class FilterItemResultsParams {
  final String searchQuery;
  final ItemsFilterState selection;
  final Location location;
  final bool isFasting;
  final int category;
  final double rating;
  final int maximumPrice;
  final int page;
  final int limit;
  FilterItemResultsParams({
    required this.searchQuery,
    required this.selection,
    required this.isFasting,
    required this.location,
    required this.category,
    required this.rating,
    required this.maximumPrice,
    required this.page,
    required this.limit,
  });
}
