import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/delete_restaurant_review_usecase.dart';

part 'delete_restaurant_review_event.dart';
part 'delete_restaurant_review_state.dart';

class DeleteRestaurantReviewBloc
    extends Bloc<DeleteRestaurantReviewEvent, DeleteRestaurantReviewState> {
  final DeleteRestaurantReviewUseCase deleteRestaurantReviewUseCase;

  DeleteRestaurantReviewBloc({required this.deleteRestaurantReviewUseCase})
      : super(DeleteRestaurantReviewInitial()) {
    on<DeleteRestaurantReviewRequestEvent>(_onDeleteRestaurantReview);
  }

  //* Edit Restaurant Review
  void _onDeleteRestaurantReview(DeleteRestaurantReviewRequestEvent event,
      Emitter<DeleteRestaurantReviewState> emit) async {
    emit(DeleteRestaurantReviewLoading());

    final failureOrDelete = await deleteRestaurantReviewUseCase(
      DeleteRestaurantReviewUseCaseParams(
        deleteRestaurantReviewRequestModel:
            event.deleteRestaurantReviewRequestModel,
      ),
    );
    emit(_eitherEditOrFailure(failureOrDelete));
  }

  DeleteRestaurantReviewState _eitherEditOrFailure(
      Either<Failure, String> failureOrDelete) {
    return failureOrDelete.fold(
      (error) => DeleteRestaurantReviewFailure(message: error.errorMessage),
      (success) => DeleteRestaurantReviewSuccess(message: success),
    );
  }
}
