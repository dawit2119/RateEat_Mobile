import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_restaurant_review_usecase.dart';
import 'restaurant_review_event.dart';
import 'restaurant_review_state.dart';

class RestaurantReviewBloc
    extends Bloc<RestaurantReviewEvent, RestaurantReviewState> {
  final AddRestaurantReviewUsecase addRestaurantReviewUsecase;

  RestaurantReviewBloc({required this.addRestaurantReviewUsecase})
      : super(const RestaurantReviewState()) {
    on<SubmitRestaurantReview>(_onSubmitRestaurantReview);
  }

  void _onSubmitRestaurantReview(
      SubmitRestaurantReview event, Emitter<RestaurantReviewState> emit) async {
    emit(const RestaurantReviewState(status: RestaurantReviewStatus.loading));
    final result = await addRestaurantReviewUsecase.call(
      AddRestaurantReviewParams(
        restaurantId: event.restaurantId,
        reviewMessage: event.reviewMessage,
        rating: event.rating,
        reviewMedia: event.reviewMedia,
      ),
    );
    result.fold(
      (failure) => emit(
        RestaurantReviewState(
          status: RestaurantReviewStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (_) => emit(
        const RestaurantReviewState(status: RestaurantReviewStatus.success),
      ),
    );
  }
}
