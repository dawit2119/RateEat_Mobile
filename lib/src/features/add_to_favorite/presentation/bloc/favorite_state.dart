part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteAdded extends FavoriteState {
  const FavoriteAdded();
}

class FavoriteRemoved extends FavoriteState {
  const FavoriteRemoved();
}

class FavoriteFailed extends FavoriteState {
  final String? message;

  const FavoriteFailed({this.message});

  @override
  List<Object> get props => [];
}
