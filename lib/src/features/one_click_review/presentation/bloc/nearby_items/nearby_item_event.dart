part of 'nearby_item_bloc.dart';

abstract class NearbyItemEvent extends Equatable {
  const NearbyItemEvent();

  @override
  List<Object> get props => [];
}

class GetNearbyItemsEvent extends NearbyItemEvent {
  final String restaurantId;
  final String itemName;
  final int page;
  final int limit;

  const GetNearbyItemsEvent({
    required this.restaurantId,
    required this.itemName,
    required this.page,
    this.limit = 10,
  });

  @override
  List<Object> get props => [restaurantId, itemName, limit, page];
}
