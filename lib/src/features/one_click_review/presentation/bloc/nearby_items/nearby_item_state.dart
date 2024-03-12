part of 'nearby_item_bloc.dart';

abstract class NearbyItemState extends Equatable {
  final String itemName;

  const NearbyItemState({required this.itemName});

  @override
  List<Object> get props => [];
}

final class NearbyItemInitial extends NearbyItemState {
  const NearbyItemInitial({required super.itemName});
}

final class NearbyItemLoading extends NearbyItemState {
  const NearbyItemLoading({required super.itemName});
}

final class NearbyItemLoaded extends NearbyItemState {
  final List<NearByItemResponse> nearbyItems;
  final bool hasReachedMax;
  final bool status;

  const NearbyItemLoaded({
    required this.status,
    this.hasReachedMax = false,
    required this.nearbyItems,
    required super.itemName,
  });

  NearbyItemLoaded copyWith({
    bool? status,
    List<NearByItemResponse>? nearbyItems,
    bool? hasReachedMax,
    String? itemName,
  }) {
    return NearbyItemLoaded(
      status: status ?? this.status,
      nearbyItems: nearbyItems ?? this.nearbyItems,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      itemName: itemName ?? this.itemName,
    );
  }

  @override
  List<Object> get props => [status, nearbyItems, hasReachedMax];

  @override
  String toString() =>
      'NearbyItemSuccess { status: $status, nearbyItems: ${nearbyItems.length}, hasReachedMax: $hasReachedMax }';
}

final class NearbyItemNextLoaded extends NearbyItemState {
  final List<NearByItemResponse> nearbyItems;

  const NearbyItemNextLoaded(
      {required this.nearbyItems, required super.itemName});

  @override
  List<Object> get props => [nearbyItems];
}

final class NearbyItemFailure extends NearbyItemState {
  final String message;

  const NearbyItemFailure({required this.message, required super.itemName});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'NearbyItemFailure { message: $message }';
}
