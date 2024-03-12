import 'package:equatable/equatable.dart';

import '../../../domain/entities/food_search_result.dart';

class SearchFoodState extends Equatable {
  const SearchFoodState();

  @override
  List<Object> get props => [];
}

class SearchFoodInitial extends SearchFoodState {}

class SearchFoodLoading extends SearchFoodState {}

class SearchFoodLoaded extends SearchFoodState {
  final List<FoodSearchResult> foods;
  final bool isSearchEvent;

  const SearchFoodLoaded({required this.foods, this.isSearchEvent = true});

  @override
  List<Object> get props => [foods, isSearchEvent];
}

class SearchFoodError extends SearchFoodState {
  final String message;

  const SearchFoodError({this.message = 'An error occurred'});

  @override
  List<Object> get props => [message];
}
