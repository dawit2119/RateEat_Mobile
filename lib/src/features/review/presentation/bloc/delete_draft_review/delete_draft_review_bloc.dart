import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_draft_review_usecase.dart';

part 'delete_draft_review_event.dart';
part 'delete_draft_review_state.dart';

class DeleteDraftReviewBloc
    extends Bloc<DeleteDraftReviewEvent, DeleteDraftReviewState> {
  final DeleteDraftItemReviewUseCase deleteDraftItemReviewUseCase;
  DeleteDraftReviewBloc({required this.deleteDraftItemReviewUseCase})
      : super(DeleteDraftItemReviewInitial()) {
    on<DeleteDraftItemReviewRequestEvent>(_onDeleteDraftReview);
  }

  //* Delete Draft Item Review
  void _onDeleteDraftReview(DeleteDraftItemReviewRequestEvent event,
      Emitter<DeleteDraftReviewState> emit) async {
    emit(DeleteDraftItemReviewLoading());

    final failureOrDelete = await deleteDraftItemReviewUseCase(
      DeleteDraftItemReviewUseCaseParams(
        deleteDraftItemReviewRequestModel:
            event.deleteDraftItemReviewRequestModel,
      ),
    );
    emit(_eitherDeleteOrFailure(failureOrDelete));
  }

  DeleteDraftReviewState _eitherDeleteOrFailure(
      Either<Failure, String> failureOrDelete) {
    return failureOrDelete.fold(
      (error) => DeleteDraftItemReviewFailure(message: error.errorMessage),
      (success) => DeleteDraftItemReviewSuccess(message: success),
    );
  }
}
