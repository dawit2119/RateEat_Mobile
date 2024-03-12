//* State
import 'package:equatable/equatable.dart';

import '../../../data/models/discover_restaurant_model.dart';

class DiscoverRestaurantState extends Equatable {
  final DiscoverRestaurantModel discoverRestaurantProps;
  const DiscoverRestaurantState({
    required this.discoverRestaurantProps,
  });

  @override
  List<Object> get props => [discoverRestaurantProps];
}
