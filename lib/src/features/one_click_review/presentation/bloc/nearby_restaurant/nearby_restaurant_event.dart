part of 'nearby_restaurant_bloc.dart';

abstract class NearbyRestaurantEvent extends Equatable {
  const NearbyRestaurantEvent();

  @override
  List<Object> get props => [];
}

class GetNearbyRestaurantEvent extends NearbyRestaurantEvent {
  final double latitude;
  final double longitude;
  final double radius;
  final int page;
  final String searchQuery;
  final int limit;

  const GetNearbyRestaurantEvent({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.page,
    required this.searchQuery,
    this.limit = 10,
  });

  @override
  List<Object> get props =>
      [latitude, longitude, radius, searchQuery, limit, page];
}
