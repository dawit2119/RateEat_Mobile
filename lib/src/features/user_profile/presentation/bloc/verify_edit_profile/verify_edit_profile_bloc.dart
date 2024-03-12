import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

part 'verify_edit_profile_event.dart';
part 'verify_edit_profile_state.dart';

class VerifyEditProfileBloc
    extends Bloc<VerifyEditProfileEvent, VerifyEditProfileState> {
  final EditProfileUseCase editProfileUseCase;
  VerifyEditProfileBloc({required this.editProfileUseCase})
      : super(VerifyEditProfileInitial()) {
    verifyEdit(SubmitVerifyEditProfileEvent event,
        Emitter<VerifyEditProfileState> emit) async {
      emit(VerifyEditProfileLoading());

      try {
        final result = await editProfileUseCase(
          EditProfileUseCaseParams(
            user: event.user,
            updateData: event.updateData,
          ),
        );

        result.fold(
          (error) => emit(
            VerifyEditProfileError(
              error: error.errorMessage,
            ),
          ),
          (response) => emit(
            VerifyEditProfileSuccess(user: response),
          ),
        );
      } catch (e) {
        emit(
          VerifyEditProfileError(
            error: e.toString(),
          ),
        );
      }
    }

    on<SubmitVerifyEditProfileEvent>(verifyEdit);
  }
}
