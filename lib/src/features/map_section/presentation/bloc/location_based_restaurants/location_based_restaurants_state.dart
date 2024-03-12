part of 'location_based_restaurants_bloc.dart';

enum RestaurantStatus { loading, loaded, error }

abstract class LocationBasedRestaurantsState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LocationBasedRestaurantsInitial
    extends LocationBasedRestaurantsState {}

final class GetLocationBasedRestaurants extends LocationBasedRestaurantsState {
  final RestaurantStatus status;
  final String? errorMessage;
  final int? count;

  GetLocationBasedRestaurants({
    required this.status,
    this.count,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, count];
}
