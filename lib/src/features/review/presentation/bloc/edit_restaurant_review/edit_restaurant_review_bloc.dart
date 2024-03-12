import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/edit_restaurant_review_usecase.dart';

part 'edit_restaurant_review_event.dart';
part 'edit_restaurant_review_state.dart';

class EditRestaurantReviewBloc
    extends Bloc<EditRestaurantReviewEvent, EditRestaurantReviewState> {
  final EditRestaurantReviewUseCase editRestaurantReviewUseCase;

  EditRestaurantReviewBloc({required this.editRestaurantReviewUseCase})
      : super(EditRestaurantReviewInitial()) {
    on<EditRestaurantReviewRequestEvent>(_onEditRestaurantReview);
  }

  //* Edit Restaurant Review
  void _onEditRestaurantReview(EditRestaurantReviewRequestEvent event,
      Emitter<EditRestaurantReviewState> emit) async {
    emit(EditRestaurantReviewLoading());

    final failureOrEdit = await editRestaurantReviewUseCase(
      EditRestaurantReviewUseCaseParams(
        editRestaurantReviewRequestModel: event.editRestaurantReviewRequest,
      ),
    );
    emit(_eitherEditOrFailure(failureOrEdit));
  }

  EditRestaurantReviewState _eitherEditOrFailure(
      Either<Failure, String> failureOrEdit) {
    return failureOrEdit.fold(
      (error) => EditRestaurantReviewFailure(message: error.errorMessage),
      (success) => EditRestaurantReviewSuccess(message: success),
    );
  }
}
