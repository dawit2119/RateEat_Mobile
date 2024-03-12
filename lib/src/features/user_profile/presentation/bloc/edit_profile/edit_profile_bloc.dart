import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/current_user/current_user_use_cases.dart';
import 'edit_profile.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileUseCase editProfileUseCase;
  EditProfileBloc({required this.editProfileUseCase})
      : super(
          EditProfileInitial(),
        ) {
    on<SubmitEditProfileEvent>(
      (event, emit) async {
        emit(
          EditProfileLoading(),
        );
        try {
          final result = await editProfileUseCase(
            EditProfileUseCaseParams(
              user: event.user,
              updateData: event.updateData,
            ),
          );

          result.fold(
            (error) => emit(
              EditProfileError(
                error: error.errorMessage,
              ),
            ),
            (response) => emit(
              EditProfileLoaded(user: response),
            ),
          );
        } catch (e) {
          emit(
            EditProfileError(
              error: e.toString(),
            ),
          );
        }
      },
    );
    on<ResetToInitialEvent>((event, emit) async {
      emit(
        EditProfileInitial(),
      );
    });
  }
}
