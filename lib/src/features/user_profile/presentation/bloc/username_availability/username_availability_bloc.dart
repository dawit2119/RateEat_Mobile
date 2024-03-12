import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/check_username_availability_use_case.dart';

part 'username_availability_event.dart';
part 'username_availability_state.dart';

class UsernameAvailabilityBloc
    extends Bloc<UsernameAvailabilityEvent, UsernameAvailabilityState> {
  final CheckUserNameAvailabilityUseCase checkUserNameAvailabilityUseCase;

  UsernameAvailabilityBloc({required this.checkUserNameAvailabilityUseCase})
      : super(const UsernameAvailabilityInitial(status: "")) {
    UsernameAvailabilityState eitherLoadedOrFailure(
        Either<Failure, bool> addedOrFailure) {
      return addedOrFailure.fold(
        (error) => UsernameAvailabilityFailed(status: error.errorMessage),
        (success) => const UsernameAvailabilitySuccess(status: "is available"),
      );
    }

    void onSuccess(event, Emitter<UsernameAvailabilityState> emit) async {
      emit(const UsernameAvailabilityLoading(
          status: "Checking username availability..."));

      final addedOrFailure = await checkUserNameAvailabilityUseCase(
          QueryParams(userName: event.userName));

      emit(eitherLoadedOrFailure(addedOrFailure));
    }

    void resetToInitial(event, Emitter<UsernameAvailabilityState> emit) async {
      emit(const UsernameAvailabilityInitial(status: ""));
    }

    on<CheckUserNameAvailability>(onSuccess);
    on<ResetUserNameToInitial>(resetToInitial);
  }
}
