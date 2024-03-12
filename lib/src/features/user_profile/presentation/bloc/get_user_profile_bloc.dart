import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/get_current_user_user_case.dart';

import '../../domain/domain.dart';

class GetUserProfileBloc
    extends Bloc<GetUserProfileEvent, GetUserProfileState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LocalProfileDataProvider localProfileDataProvider;

  GetUserProfileBloc(
      {required this.getCurrentUserUseCase,
      required this.localProfileDataProvider})
      : super(UserProfileInitial()) {
    on<GetUserProfileEvent>(_getUserProfile);
  }

  _getUserProfile(
    GetUserProfileEvent event,
    Emitter<GetUserProfileState> emit,
  ) async {
    emit(UserProfileLoading());

    final result = await getCurrentUserUseCase.call(NoParams());
    final User? localUser;
    if (result.isLeft()) {
      localUser = await localProfileDataProvider.getProfileData();
    } else {
      localUser = null;
      try {
        await localProfileDataProvider.cacheProfileData(result.getOrElse(() {
          throw Exception("failed to cache data");
        }));
      } catch (e) {
        //failed to cache
      }
    }

    result.fold(
      (failure) async {
        if (localUser == null) {
          emit(GetUserProfileError(error: "Unable to get user info"));
        } else {
          emit(UserProfileLoaded(user: localUser, isLocalData: true));
        }
      },
      (user) async {
        emit(UserProfileLoaded(user: user, isLocalData: false));
      },
    );
  }
}

//* Event
class GetUserProfileEvent extends Equatable {
  final String userId;

  const GetUserProfileEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

//* State
class GetUserProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends GetUserProfileState {}

class UserProfileLoading extends GetUserProfileState {}

class UserProfileLoaded extends GetUserProfileState {
  final User user;
  final bool isLocalData;
  UserProfileLoaded({required this.user, required this.isLocalData});

  @override
  List<Object?> get props => [user, isLocalData];
}

class GetUserProfileError extends GetUserProfileState {
  final String error;
  GetUserProfileError({required this.error});
  @override
  List<Object?> get props => [error];
}
