import 'package:equatable/equatable.dart';

import '../../../../discover_item/data/models/search_result.dart';
import '../../../../homepage/domain/entities/item.dart';

class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class RestaurantSearchLoaded extends SearchState {
  final List<RestaurantResult> results;
  RestaurantSearchLoaded({required this.results});
  @override
  List<Object?> get props => [results];
}

class ItemSearchLoaded extends SearchState {
  final List<Item> results;
  ItemSearchLoaded({required this.results});
  @override
  List<Object?> get props => [results];
}

class SearchError extends SearchState {
  final String error;
  SearchError({required this.error});
}
