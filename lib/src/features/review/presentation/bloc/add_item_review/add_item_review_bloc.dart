import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';

import '../../../domain/use_cases/add_item_review_usecase.dart';

part 'add_item_review_event.dart';
part 'add_item_review_state.dart';

class AddItemReviewBloc extends Bloc<AddItemReviewEvent, AddItemReviewState> {
  final AddItemReviewUseCase addItemReviewUseCase;

  AddItemReviewBloc({required this.addItemReviewUseCase})
      : super(AddItemReviewInitial()) {
    on<AddItemReviewRequestEvent>(_onAddItemReview);
  }

  //* Add Item Review
  void _onAddItemReview(
      AddItemReviewRequestEvent event, Emitter<AddItemReviewState> emit) async {
    emit(AddItemReviewLoading());

    final failureOrAdd = await addItemReviewUseCase(
      AddItemReviewUseCaseParams(
        addItemReviewRequestModel: event.addItemReviewRequest,
        isCandidateItem: event.isCandidateItem,
      ),
    );
    emit(_eitherAddOrFailure(failureOrAdd));
  }

  AddItemReviewState _eitherAddOrFailure(Either<Failure, bool> failureOrAdd) {
    return failureOrAdd.fold(
      (error) => AddItemReviewFailure(message: error.errorMessage),
      (success) => AddItemReviewSuccess(),
    );
  }
}
