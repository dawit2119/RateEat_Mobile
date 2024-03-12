import 'package:equatable/equatable.dart';

abstract class SearchRestaurantEvent extends Equatable {
  const SearchRestaurantEvent();

  @override
  List<Object> get props => [];
}

class RestaurantSearchSubmitted extends SearchRestaurantEvent {
  final String query;
  const RestaurantSearchSubmitted({required this.query});

  @override
  List<Object> get props => [query];
}
