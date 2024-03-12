import 'package:equatable/equatable.dart';

abstract class HomePageNearbyRestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetNearByRestaurants extends HomePageNearbyRestEvent {
  final double lat;
  final double lng;
  final List<String> tags;
  final int page;
  final int limit;
  GetNearByRestaurants({
    required this.lat,
    required this.lng,
    required this.tags,
    required this.page,
    this.limit = 7,
  });
}
