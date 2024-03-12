import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/use_cases.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AddItemToFavoriteUseCase addToFavorite;
  final RemoveItemFromFavoriteUseCase removeFromFavorite;
  final AddRestaurantToFavoriteUseCase addRestaurantToFavorite;
  final RemoveRestaurantFromFavoriteUseCase removeRestaurantFromFavorite;

  FavoriteBloc(
      {required this.addToFavorite,
      required this.removeFromFavorite,
      required this.addRestaurantToFavorite,
      required this.removeRestaurantFromFavorite})
      : super(FavoriteInitial()) {
    //* Add To Favorite
    FavoriteState eitherAddedOrFailure(Either<Failure, bool> addedOrFailure) {
      return addedOrFailure.fold(
        (error) => FavoriteFailed(message: error.errorMessage),
        (success) => const FavoriteAdded(),
      );
    }

    void onAddToFavorite(event, Emitter<FavoriteState> emit) async {
      emit(FavoriteLoading());

      final Either<Failure, bool> addedOrFailure;
      if (event.itemId != null) {
        addedOrFailure =
            await addToFavorite(ItemFavoriteParams(itemId: event.itemId));
      } else {
        addedOrFailure = await addRestaurantToFavorite(
            RestaurantFavoriteParams(restaurantId: event.restaurantId));
      }

      emit(eitherAddedOrFailure(addedOrFailure));
    }

    //* Remove From Favorite
    FavoriteState eitherRemoveOrFailure(
        Either<Failure, bool> removedOrFailure) {
      return removedOrFailure.fold(
        (error) => FavoriteFailed(message: error.errorMessage),
        (success) => const FavoriteRemoved(),
      );
    }

    void onRemoveToFavorite(event, Emitter<FavoriteState> emit) async {
      emit(FavoriteLoading());

      final Either<Failure, bool> removedOrFailure;
      if (event.itemId != null) {
        removedOrFailure =
            await removeFromFavorite(ItemFavoriteParams(itemId: event.itemId));
      } else {
        removedOrFailure = await removeRestaurantFromFavorite(
            RestaurantFavoriteParams(restaurantId: event.restaurantId));
      }
      emit(eitherRemoveOrFailure(removedOrFailure));
    }

    on<AddToFavorite>(onAddToFavorite);
    on<RemoveFromFavorite>(onRemoveToFavorite);
    on<ResetFavorite>((ResetFavorite event, emit) {
      emit(FavoriteInitial());
    });
  }
}
