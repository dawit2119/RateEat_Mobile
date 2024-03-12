import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/map_section/map_section.dart';

abstract class HomePageNearbyRestaurantState extends Equatable {
  @override
  List<Object?> get props => [];
}

abstract class RestaurantStateWithRestaurants
    extends HomePageNearbyRestaurantState {
  List<RestaurantModel> get restaurants;
  bool get hasReachedMax;
}

class NearbyInitial extends HomePageNearbyRestaurantState {}

class NearbyLoading extends HomePageNearbyRestaurantState {}

class NearbyRestaurantNextLoading extends HomePageNearbyRestaurantState {
  final List<RestaurantModel> restaurants;
  final int page;
  NearbyRestaurantNextLoading({
    required this.restaurants,
    required this.page,
  });
}

class NearbyRestaurantFetchedFromLocal extends HomePageNearbyRestaurantState
    implements RestaurantStateWithRestaurants {
  @override
  final List<RestaurantModel> restaurants;
  @override
  final bool hasReachedMax = true;
  NearbyRestaurantFetchedFromLocal({required this.restaurants});
}

class NearbyRestaurantFetched extends HomePageNearbyRestaurantState
    implements RestaurantStateWithRestaurants {
  @override
  final List<RestaurantModel> restaurants;
  @override
  final bool hasReachedMax;
  final int page;
  final int? totalItems;
  NearbyRestaurantFetched({
    required this.restaurants,
    this.hasReachedMax = false,
    this.page = 1,
    this.totalItems,
  });
}

class NearbyRestaurantFailure extends HomePageNearbyRestaurantState {
  final String err;
  NearbyRestaurantFailure({required this.err});
}
