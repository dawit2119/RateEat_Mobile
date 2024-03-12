import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class NearbyRestaurantsResponse extends Equatable {
  final List<RestaurantModel> restaurants;
  final int totalItems;

  const NearbyRestaurantsResponse(
      {required this.restaurants, required this.totalItems});

  @override
  List<Object?> get props => [restaurants, totalItems];
}
