part of 'location_based_restaurants_bloc.dart';

abstract class LocationBasedRestaurantsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetRestaurantsCountEvent extends LocationBasedRestaurantsEvent {
  final double lat;
  final double long;
  final double radius;

  GetRestaurantsCountEvent(
      {required this.lat, required this.long, required this.radius});

  @override
  List<Object> get props => [lat, long, radius];
}
