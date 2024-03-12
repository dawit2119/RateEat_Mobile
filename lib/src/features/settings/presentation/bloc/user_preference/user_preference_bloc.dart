import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/user_preference/user_preference.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class UserPreferenceBloc
    extends Bloc<UserPreferenceEvent, UserPreferenceState> {
  final UpdateUserPreferenceUseCase updateUserPreferenceUseCase;
  final GetUserPreferenceUseCase getUserPreferenceUseCase;
  UserPreferenceBloc(
      {required this.updateUserPreferenceUseCase,
      required this.getUserPreferenceUseCase})
      : super(UserPreferenceInitial()) {
    on<UpdateUserPreference>((event, emit) async {
      emit(UserPreferenceUpdateLoading());
      final res =
          await updateUserPreferenceUseCase(UpdateUserPreferenceUseCaseParams(
        preferredWalkingDistance: event.preferredWalkingDistance,
        preferredDrivingDistance: event.preferredDrivingDistance,
        minNumberOfReviews: event.minNumberOfReviews,
      ));
      res.fold((failure) {
        emit(UserPreferenceUpdateFailed());
      }, (r) {
        emit(UserPreferenceUpdateSuccess());
      });
    });
    on<GetPreviousPreference>((event, emit) async {
      emit(UserPreferenceInitial());
      final res = await getUserPreferenceUseCase(NoParams());
      res.fold((failure) {
        emit(PreviousPreferencesFetchFailed());
      }, (userPreference) {
        emit(PreviousPreferencesFetched(userPreference: userPreference));
      });
    });
  }
}
