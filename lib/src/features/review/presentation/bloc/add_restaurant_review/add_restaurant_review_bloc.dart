import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_restaurant_review_request_model.dart';

import '../../../domain/use_cases/add_restaurant_review_usecase.dart';

part 'add_restaurant_review_event.dart';
part 'add_restaurant_review_state.dart';

class AddRestaurantReviewBloc
    extends Bloc<AddRestaurantReviewEvent, AddRestaurantReviewState> {
  final AddRestaurantReviewUseCase addRestaurantReviewUseCase;

  AddRestaurantReviewBloc({required this.addRestaurantReviewUseCase})
      : super(AddRestaurantReviewInitial()) {
    on<AddRestaurantReviewRequestEvent>(_onAddRestaurantReview);
  }

  //* Add Restaurant Review
  void _onAddRestaurantReview(AddRestaurantReviewRequestEvent event,
      Emitter<AddRestaurantReviewState> emit) async {
    emit(AddRestaurantReviewLoading());

    final failureOrAdd = await addRestaurantReviewUseCase(
      AddRestaurantReviewUseCaseParams(
        addRestaurantReviewRequestModel: event.addRestaurantReviewRequest,
      ),
    );
    emit(_eitherAddOrFailure(failureOrAdd));
  }

  AddRestaurantReviewState _eitherAddOrFailure(
      Either<Failure, String> failureOrAdd) {
    return failureOrAdd.fold(
      (error) => AddRestaurantReviewFailure(message: error.errorMessage),
      (success) => AddRestaurantReviewSuccess(message: success),
    );
  }
}
