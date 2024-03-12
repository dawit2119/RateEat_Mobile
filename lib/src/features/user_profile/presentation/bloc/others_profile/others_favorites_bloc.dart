import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class OthersFavoriteBloc
    extends Bloc<GetOthersFavoritesEvent, OthersFavoritesState> {
  final GetOtherUserFavoritesUseCase getOtherUserFavoritesUseCase;

  OthersFavoriteBloc({required this.getOtherUserFavoritesUseCase})
      : super(OthersFavoritesInitial()) {
    on<GetOthersFavoritesEvent>(_getOthersFavorites);
  }

  void _getOthersFavorites(
      GetOthersFavoritesEvent event, Emitter<OthersFavoritesState> emit) async {
    emit(OthersFavoritesLoading());
    try {
      final result = await getOtherUserFavoritesUseCase(event.userId);
      result.fold(
        (error) => emit(
          OthersFavoritesError(
            error: error.errorMessage,
          ),
        ),
        (userFavorites) => emit(
          OthersFavoritesLoaded(favorites: userFavorites),
        ),
      );
    } catch (e) {
      emit(
        OthersFavoritesError(
          error: e.toString(),
        ),
      );
    }
  }
}

//*Event
class GetOthersFavoritesEvent extends Equatable {
  final String userId;

  const GetOthersFavoritesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// * State
class OthersFavoritesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OthersFavoritesInitial extends OthersFavoritesState {}

class OthersFavoritesLoading extends OthersFavoritesState {}

class OthersFavoritesLoaded extends OthersFavoritesState {
  final List<UserFavorite> favorites;
  OthersFavoritesLoaded({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}

class OthersFavoritesError extends OthersFavoritesState {
  final String error;
  OthersFavoritesError({required this.error});
  @override
  List<Object?> get props => [error];
}
