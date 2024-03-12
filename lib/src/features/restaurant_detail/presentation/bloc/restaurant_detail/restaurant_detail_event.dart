import 'package:equatable/equatable.dart';

class RestaurantDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRestaurantDetailEvent extends RestaurantDetailEvent {
  final String restaurantId;
  final double? longitude;
  final double? latitude;
  GetRestaurantDetailEvent(
      {required this.restaurantId, this.longitude, this.latitude});

  @override
  List<Object?> get props => [restaurantId];
}
