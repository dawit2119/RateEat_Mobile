import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_item_review_usecase.dart';

part 'delete_item_review_event.dart';
part 'delete_item_review_state.dart';

class DeleteItemReviewBloc
    extends Bloc<DeleteItemReviewEvent, DeleteItemReviewState> {
  final DeleteItemReviewUseCase deleteItemReviewUseCase;
  DeleteItemReviewBloc({required this.deleteItemReviewUseCase})
      : super(DeleteItemReviewInitial()) {
    on<DeleteItemReviewRequestEvent>(_onDeleteItemReview);
  }

  //* Delete Item Review
  void _onDeleteItemReview(DeleteItemReviewRequestEvent event,
      Emitter<DeleteItemReviewState> emit) async {
    emit(DeleteItemReviewLoading());

    final failureOrDelete = await deleteItemReviewUseCase(
      DeleteItemReviewUseCaseParams(
        deleteItemReviewRequestModel: event.deleteItemReviewRequestModel,
      ),
    );
    emit(_eitherDeleteOrFailure(failureOrDelete));
  }

  DeleteItemReviewState _eitherDeleteOrFailure(
      Either<Failure, String> failureOrDelete) {
    return failureOrDelete.fold(
      (error) => DeleteItemReviewFailure(message: error.errorMessage),
      (success) => DeleteItemReviewSuccess(message: success),
    );
  }
}
