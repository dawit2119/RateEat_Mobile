part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class AddToFavorite extends FavoriteEvent {
  final String? itemId;
  final String? restaurantId;
  const AddToFavorite({required this.itemId, required this.restaurantId});

  @override
  List<Object?> get props => [itemId, restaurantId];
}

class RemoveFromFavorite extends FavoriteEvent {
  final String? itemId;
  final String? restaurantId;
  const RemoveFromFavorite({
    required this.itemId,
    required this.restaurantId,
  });

  @override
  List<Object?> get props => [itemId, restaurantId];
}

class ResetFavorite extends FavoriteEvent {
  @override
  List<Object?> get props => [];
}
