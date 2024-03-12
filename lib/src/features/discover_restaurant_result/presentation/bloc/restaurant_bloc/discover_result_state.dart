import 'package:equatable/equatable.dart';

import '../../../data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';

class FetchDiscoverRestaurantResultState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiscoverRestaurantInitial extends FetchDiscoverRestaurantResultState {}

class DiscoverRestaurantLoading extends FetchDiscoverRestaurantResultState {}

class DiscoverRestaurantsNextLoading
    extends FetchDiscoverRestaurantResultState {
  final List<DiscoverRestaurantResultModel> discoveredRestaurantResults;

  DiscoverRestaurantsNextLoading({
    required this.discoveredRestaurantResults,
  });
}

class DiscoverRestaurantLoaded extends FetchDiscoverRestaurantResultState {
  final List<DiscoverRestaurantResultModel> discoveredRestaurantResults;
  final bool hasReachedMax;
  final bool searchLoadingStatus;
  DiscoverRestaurantLoaded({
    required this.discoveredRestaurantResults,
    this.hasReachedMax = false,
    this.searchLoadingStatus = true,
  });
}

class DiscoverRestaurantError extends FetchDiscoverRestaurantResultState {
  final String errorMessage;
  DiscoverRestaurantError({required this.errorMessage});
}
