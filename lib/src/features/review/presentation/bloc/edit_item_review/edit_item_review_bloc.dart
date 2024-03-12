import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/edit_item_review_usecase.dart';

part 'edit_item_review_event.dart';
part 'edit_item_review_state.dart';

class EditItemReviewBloc
    extends Bloc<EditItemReviewEvent, EditItemReviewState> {
  final EditItemReviewUseCase editItemReviewUseCase;
  EditItemReviewBloc({required this.editItemReviewUseCase})
      : super(EditItemReviewInitial()) {
    on<EditItemReviewRequestEvent>(_onEditItemReview);
  }

  //* Edit Item Review
  void _onEditItemReview(EditItemReviewRequestEvent event,
      Emitter<EditItemReviewState> emit) async {
    emit(EditItemReviewLoading());

    final failureOrEdit = await editItemReviewUseCase(
      EditItemReviewUseCaseParams(
        editItemReviewRequestModel: event.editItemReviewRequest,
      ),
    );
    emit(_eitherEditOrFailure(failureOrEdit));
  }

  EditItemReviewState _eitherEditOrFailure(
      Either<Failure, String> failureOrEdit) {
    return failureOrEdit.fold(
      (error) => EditItemReviewFailure(message: error.errorMessage),
      (success) => EditItemReviewSuccess(message: success),
    );
  }
}
