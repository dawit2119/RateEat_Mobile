import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/send_draft_to_review_usecase.dart';

part 'draft_to_review_event.dart';
part 'draft_to_review_state.dart';

class DraftToReviewBloc extends Bloc<DraftToReviewEvent, DraftToReviewState> {
  final SendDraftToReviewUSeCase sendDraftToReviewUSeCase;
  DraftToReviewBloc({required this.sendDraftToReviewUSeCase})
      : super(DraftToReviewInitial()) {
    on<SendDraftToReviewEvent>(_onDraftToReview);
  }

  //* Add Item Review
  void _onDraftToReview(
      SendDraftToReviewEvent event, Emitter<DraftToReviewState> emit) async {
    emit(DraftToReviewLoading());

    final failureOrAdd = await sendDraftToReviewUSeCase(
      SendDraftToReviewUSeCaseParams(
        draftToReviewRequestModel: event.draftToReviewRequest,
      ),
    );
    emit(_eitherAddOrFailure(failureOrAdd));
  }

  DraftToReviewState _eitherAddOrFailure(Either<Failure, String> failureOrAdd) {
    return failureOrAdd.fold(
      (error) => DraftToReviewFailure(message: error.errorMessage),
      (success) => DraftToReviewSuccess(message: success),
    );
  }
}
