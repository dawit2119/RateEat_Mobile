import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_food_review_usecase.dart';
import 'food_review_event.dart';
import 'food_review_state.dart';

class FoodReviewBloc extends Bloc<FoodReviewEvent, FoodReviewState> {
  final AddFoodReviewUsecase addFoodReviewUsecase;

  FoodReviewBloc({required this.addFoodReviewUsecase})
      : super(const FoodReviewState()) {
    on<SubmitFoodReview>(_onSubmitFoodReview);
  }

  void _onSubmitFoodReview(
      SubmitFoodReview event, Emitter<FoodReviewState> emit) async {
    emit(const FoodReviewState(status: FoodReviewStatus.loading));
    final result = await addFoodReviewUsecase.call(
      AddFoodReviewParams(
        foodId: event.foodId,
        reviewMessage: event.reviewMessage,
        rating: event.rating,
        reviewMedia: event.reviewMedia,
      ),
    );
    result.fold(
      (failure) => emit(
        FoodReviewState(
          status: FoodReviewStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (_) => emit(
        const FoodReviewState(status: FoodReviewStatus.success),
      ),
    );
  }
}
