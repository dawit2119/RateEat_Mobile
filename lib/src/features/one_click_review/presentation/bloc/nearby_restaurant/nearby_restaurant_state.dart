part of 'nearby_restaurant_bloc.dart';

abstract class NearByRestaurantState extends Equatable {
  final String searchQuery;
  const NearByRestaurantState({required this.searchQuery});
  @override
  List<Object> get props => [];
}

final class NearbyRestaurantInitial extends NearByRestaurantState {
  const NearbyRestaurantInitial({required super.searchQuery});
}

final class NearbyRestaurantLoading extends NearByRestaurantState {
  const NearbyRestaurantLoading({required super.searchQuery});
}

final class NearbyRestaurantLoaded extends NearByRestaurantState {
  final bool status;
  final bool hasReachedMax;
  final List<NearByRestaurantResponse> nearbyRestaurants;

  const NearbyRestaurantLoaded({
    required this.nearbyRestaurants,
    required super.searchQuery,
    required this.status,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [nearbyRestaurants, status, hasReachedMax];
}

final class NearbyRestaurantNextLoaded extends NearByRestaurantState {
  final List<NearByRestaurantResponse> nearbyRestaurants;

  const NearbyRestaurantNextLoaded(
      {required this.nearbyRestaurants, required super.searchQuery});

  @override
  List<Object> get props => [nearbyRestaurants];
}

final class NearbyRestaurantFailure extends NearByRestaurantState {
  final String message;

  const NearbyRestaurantFailure(
      {required this.message, required super.searchQuery});

  @override
  List<Object> get props => [message];
}
