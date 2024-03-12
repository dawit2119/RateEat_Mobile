import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/add_review_to_draft_usecase.dart';

part 'add_review_to_draft_event.dart';
part 'add_review_to_draft_state.dart';

class AddReviewToDraftBloc
    extends Bloc<AddReviewToDraftEvent, AddReviewToDraftState> {
  final AddReviewToDraftUseCase addReviewToDraftUseCase;

  AddReviewToDraftBloc({required this.addReviewToDraftUseCase})
      : super(AddReviewToDraftInitial()) {
    on<AddDraftRequestEvent>(_onAddDraftReview);
  }

  //* Add Item Review
  void _onAddDraftReview(
      AddDraftRequestEvent event, Emitter<AddReviewToDraftState> emit) async {
    emit(AddReviewToDraftLoading());

    final failureOrAdd = await addReviewToDraftUseCase(
      DraftReviewUseCaseParams(
        draftReviewRequestModel: event.draftReviewRequestModel,
      ),
    );
    emit(_eitherAddOrFailure(failureOrAdd));
  }

  AddReviewToDraftState _eitherAddOrFailure(
      Either<Failure, String> failureOrAdd) {
    return failureOrAdd.fold(
      (error) => AddReviewToDraftFailure(message: error.errorMessage),
      (success) => AddReviewToDraftSuccess(message: success),
    );
  }
}
