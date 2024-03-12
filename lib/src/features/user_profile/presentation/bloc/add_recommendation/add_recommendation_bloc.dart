import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/add_item_recommendation_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/add_restaurant_recommendation_use_case.dart';

import 'add_recommendation_event.dart';
import 'add_recommendation_state.dart';

class AddRecommendationBloc
    extends Bloc<AddRecommendationEvent, AddRecommendationState> {
  final AddItemRecommendationUseCase addItemRecommendationUseCase;
  final AddRestaurantRecommendationUseCase addRestaurantRecommendationUseCase;

  AddRecommendationBloc(
      {required this.addItemRecommendationUseCase,
      required this.addRestaurantRecommendationUseCase})
      : super(AddRecommendationInitial()) {
    on<AddNewRecommendationEvent>((event, emit) async {
      emit(AddRecommendationLoading());
      if (event.isItem) {
        final res = await addItemRecommendationUseCase(
            ItemRecommendationUseCaseParams(
                itemId: event.itemId!, message: event.message));
        res.fold((error) {
          emit(AddRecommendationFailed());
        }, (success) {
          emit(AddRecommendationSuccess());
        });
      } else {
        final res = await addRestaurantRecommendationUseCase(
            RetaurantecommendationUseCaseParams(
                restaurantId: event.restaurantId!, message: event.message));
        res.fold((error) {
          emit(AddRecommendationFailed());
        }, (success) {
          emit(AddRecommendationSuccess());
        });
      }
    });

    on<ResetAddRecommendation>((event, emit) {
      emit(AddRecommendationInitial());
    });
  }
}
