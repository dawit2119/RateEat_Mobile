import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';

class RestaurantSelectedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestaurantSelected extends RestaurantSelectedEvent {
  final RestaurantResult selectedRestaurant;

  RestaurantSelected({required this.selectedRestaurant});
  @override
  List<Object?> get props => [selectedRestaurant];
}
