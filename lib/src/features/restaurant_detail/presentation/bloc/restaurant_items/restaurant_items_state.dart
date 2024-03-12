part of 'restaurant_items_bloc.dart';

abstract class RestaurantItemsState extends Equatable {
  @override
  List<Object> get props => [];
}

final class GetRestaurantItemsState extends RestaurantItemsState {
  final ItemStatus status;
  final String? errorMessage;
  final List<ItemModel>? items;
  final bool hasReachedMax;

  GetRestaurantItemsState({
    this.hasReachedMax = false,
    this.status = ItemStatus.loading,
    this.items,
    this.errorMessage,
  });

  GetRestaurantItemsState copyWith({
    ItemStatus? status,
    String? errorMessage,
    List<ItemModel>? items,
    bool? hasReachedMax,
  }) {
    return GetRestaurantItemsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [items ?? [], status];
}

class RestaurantPopularItemsFetched extends RestaurantItemsState {
  final List<RestaurantMenuItem> popularItems;

  RestaurantPopularItemsFetched({
    required this.popularItems,
  });
  @override
  List<Object> get props => [popularItems];
}

class RestaurantPopularItemsFetching extends RestaurantItemsState {}

class RestaurantPopularItemsFetchingFailed extends RestaurantItemsState {
  final String message;

  RestaurantPopularItemsFetchingFailed({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
