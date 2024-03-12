import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_highest_rated_food_usecase.dart';
import '../../../domain/usecases/search_food_usecase.dart';
import 'search_food_event.dart';
import 'search_food_state.dart';

class SearchFoodBloc extends Bloc<GetRestaurantItemsEvent, SearchFoodState> {
  final SearchFoodUseCase searchFoodUseCase;
  final GetHighestRatedFoodUsecase getHighestRatedFoodUsecase;
  SearchFoodBloc({
    required this.searchFoodUseCase,
    required this.getHighestRatedFoodUsecase,
  }) : super(SearchFoodInitial()) {
    on<SearchFoodEvent>(_onSearchFood);
    on<GetHighestedRatedRestaurantItems>(_onGetHighestedRatedRestaurantItems);
  }

  void _onSearchFood(
      SearchFoodEvent event, Emitter<SearchFoodState> emit) async {
    emit(SearchFoodLoading());
    try {
      final foods = await searchFoodUseCase(SearchFoodParams(
          restaurantId: event.restaurantId, query: event.query));
      foods.fold(
          (l) => emit(SearchFoodError(message: l.errorMessage)),
          (r) => emit(SearchFoodLoaded(
                foods: r,
                isSearchEvent: true,
              )));
    } catch (e) {
      emit(SearchFoodError(message: e.toString()));
    }
  }

  void _onGetHighestedRatedRestaurantItems(
      GetHighestedRatedRestaurantItems event,
      Emitter<SearchFoodState> emit) async {
    emit(SearchFoodLoading());
    try {
      final foods = await getHighestRatedFoodUsecase(event.restaurantId);
      if (state is! SearchFoodLoaded) {
        foods.fold(
            (l) => emit(SearchFoodError(message: l.errorMessage)),
            (r) => emit(SearchFoodLoaded(
                  foods: r,
                  isSearchEvent: false,
                )));
      }
    } catch (e) {
      if (state is! SearchFoodLoaded) {
        emit(SearchFoodError(message: e.toString()));
      }
    }
  }
}
