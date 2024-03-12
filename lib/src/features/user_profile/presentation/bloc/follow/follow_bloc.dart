import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/follow/follow_event.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/follow/follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final FollowUserUseCase followUseCase;
  final UnFollowUserUseCase unfollowUseCase;
  FollowBloc({required this.followUseCase, required this.unfollowUseCase})
      : super(FollowUserInitial()) {
    on<FollowUserEvent>((event, emit) async {
      emit(FollowUserLoading());
      try {
        await followUseCase(event.userId);
        emit(FollowUserSuccess());
      } catch (e) {
        emit(FollowUserFailed());
      }
    });
    on<UnfollowUserEvent>((event, emit) async {
      emit(UnfollowUserLoading());
      try {
        await unfollowUseCase(event.userId);
        emit(UnfollowUserSuccess());
      } catch (e) {
        emit(UnfollowUserFailed());
      }
    });
  }
}
