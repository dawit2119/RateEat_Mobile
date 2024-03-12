import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

class GetOthersProfileBloc
    extends Bloc<GetOthersProfileEvent, GetOthersProfileState> {
  final GetOtherUserUseCase getOtherUserUseCase;

  GetOthersProfileBloc({
    required this.getOtherUserUseCase,
  }) : super(OthersProfileInitial()) {
    on<GetOthersProfileEvent>(_getOthersProfile);
  }

  _getOthersProfile(
    GetOthersProfileEvent event,
    Emitter<GetOthersProfileState> emit,
  ) async {
    emit(OthersProfileLoading());
    try {
      final result = await getOtherUserUseCase(event.userId);
      result.fold(
        (error) => emit(
          GetOthersProfileError(error: error.errorMessage),
        ),
        (user) => emit(
          OthersProfileLoaded(user: user),
        ),
      );
    } catch (e) {
      emit(
        GetOthersProfileError(error: e.toString()),
      );
    }
  }
}

//* Event
class GetOthersProfileEvent extends Equatable {
  final String userId;

  const GetOthersProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

//* State
class GetOthersProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OthersProfileInitial extends GetOthersProfileState {}

class OthersProfileLoading extends GetOthersProfileState {}

class OthersProfileLoaded extends GetOthersProfileState {
  final User user;
  OthersProfileLoaded({required this.user});
}

class GetOthersProfileError extends GetOthersProfileState {
  final String error;
  GetOthersProfileError({required this.error});
  @override
  List<Object?> get props => [error];
}
