import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';

abstract class SearchRestaurantState extends Equatable {
  const SearchRestaurantState();

  @override
  List<Object> get props => [];
}

//* Search States
class SearchRestaurantInitial extends SearchRestaurantState {}

class SearchRestaurantLoading extends SearchRestaurantState {}

class SearchRestaurantSuccess extends SearchRestaurantState {
  final List<RestaurantResult> restaurants;

  const SearchRestaurantSuccess(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class SearchRestaurantsError extends SearchRestaurantState {
  final String message;

  const SearchRestaurantsError({required this.message});

  @override
  List<Object> get props => [message];
}
