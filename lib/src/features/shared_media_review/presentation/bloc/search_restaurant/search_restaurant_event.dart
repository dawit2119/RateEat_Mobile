import 'package:equatable/equatable.dart';

class GetRestaurantsEvent extends Equatable {
  const GetRestaurantsEvent();
  @override
  List<Object> get props => [];
}

class SearchRestaurantEvent extends GetRestaurantsEvent {
  final String query;

  const SearchRestaurantEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class GetNearbyRestaurantEvent extends GetRestaurantsEvent {
  final double latitude;
  final double longitude;

  const GetNearbyRestaurantEvent(
      {required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}
