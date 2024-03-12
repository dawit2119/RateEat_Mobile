import 'package:equatable/equatable.dart';

import '../../../domain/entities/restaurant_search_result.dart';

class SearchRestaurantState extends Equatable {
  const SearchRestaurantState();

  @override
  List<Object> get props => [];
}

class SearchRestaurantInitial extends SearchRestaurantState {}

class SearchRestaurantLoading extends SearchRestaurantState {}

class SearchRestaurantLoaded extends SearchRestaurantState {
  final List<RestaurantSearchResult> restaurants;
  final bool isSearchEvent;

  const SearchRestaurantLoaded(
      {required this.restaurants, this.isSearchEvent = true});

  @override
  List<Object> get props => [restaurants, isSearchEvent];
}

class SearchRestaurantError extends SearchRestaurantState {
  final String message;

  const SearchRestaurantError({this.message = 'An error occurred'});

  @override
  List<Object> get props => [
        message,
      ];
}
