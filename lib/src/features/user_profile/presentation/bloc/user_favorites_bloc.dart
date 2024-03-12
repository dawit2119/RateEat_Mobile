import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

import '../../domain/domain.dart';

class UserFavoriteBloc extends Bloc<GetUserFavoritesEvent, UserFavoritesState> {
  final GetUserFavoritesUseCase getUserFavoritesUseCase;

  UserFavoriteBloc({required this.getUserFavoritesUseCase})
      : super(UserFavoritesInitial()) {
    on<GetUserFavoritesEvent>(_getUserFavorites);
  }

  void _getUserFavorites(
      GetUserFavoritesEvent event, Emitter<UserFavoritesState> emit) async {
    emit(UserFavoritesLoading());
    try {
      final result = await getUserFavoritesUseCase(event.userId);
      final List<UserFavorite>? localUserFavorites;
      if (result.isLeft()) {
        localUserFavorites =
            dpLocator<LocalProfileDataProvider>().getUserFavorites();
        if (localUserFavorites == null) {
          throw Exception("Unable to get favorites");
        }
      } else {
        localUserFavorites = [];
      }
      result.fold(
        (error) {
          emit(
            UserFavoritesLoaded(
              favorites: localUserFavorites!,
              isLocalData: true,
            ),
          );
        },
        (userFavorites) {
          try {
            dpLocator<LocalProfileDataProvider>()
                .cacheUserFavorites(userFavorites);
          } catch (e) {
            //failed to cache
          }
          emit(
            UserFavoritesLoaded(favorites: userFavorites, isLocalData: false),
          );
        },
      );
    } catch (e) {
      emit(
        UserFavoritesError(
          error: e.toString(),
        ),
      );
    }
  }
}

//*Event
class GetUserFavoritesEvent extends Equatable {
  final String userId;

  const GetUserFavoritesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// * State
class UserFavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserFavoritesInitial extends UserFavoritesState {}

class UserFavoritesLoading extends UserFavoritesState {}

class UserFavoritesLoaded extends UserFavoritesState {
  final List<UserFavorite> favorites;
  final bool isLocalData;
  UserFavoritesLoaded({required this.favorites, required this.isLocalData});

  @override
  List<Object?> get props => [favorites, isLocalData];
}

class UserFavoritesError extends UserFavoritesState {
  final String error;
  UserFavoritesError({required this.error});
  @override
  List<Object?> get props => [error];
}
