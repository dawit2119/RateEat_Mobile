import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';

class SelectedRestaurantState extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectedRestaurantInitial extends SelectedRestaurantState {}

class RestaurantSelectedSuccess extends SelectedRestaurantState {
  final RestaurantResult selectedRestaurant;

  RestaurantSelectedSuccess(this.selectedRestaurant);

  @override
  List<Object> get props => [selectedRestaurant];
}
