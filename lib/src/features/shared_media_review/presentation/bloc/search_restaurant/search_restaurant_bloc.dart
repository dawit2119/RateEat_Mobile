import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_nearby_restaurant_usecase.dart';
import '../../../domain/usecases/search_restaurant_usecase.dart';
import 'search_restaurant_event.dart';
import 'search_restaurant_state.dart';

class SearchRestaurantBloc
    extends Bloc<GetRestaurantsEvent, SearchRestaurantState> {
  final SearchRestaurantUseCase searchRestaurantUseCase;
  final GetNearbyRestaurantUsecase getNearbyRestaurantUsecase;
  SearchRestaurantBloc({
    required this.searchRestaurantUseCase,
    required this.getNearbyRestaurantUsecase,
  }) : super(SearchRestaurantInitial()) {
    on<SearchRestaurantEvent>(_onSearchRestaurant);
    on<GetNearbyRestaurantEvent>(_onGetNearbyRestaurants);
  }

  void _onSearchRestaurant(
      SearchRestaurantEvent event, Emitter<SearchRestaurantState> emit) async {
    emit(SearchRestaurantLoading());
    try {
      final restaurants = await searchRestaurantUseCase(event.query);
      restaurants.fold(
          (l) => emit(SearchRestaurantError(message: l.errorMessage)),
          (r) => emit(SearchRestaurantLoaded(
                restaurants: r,
                isSearchEvent: true,
              )));
    } catch (e) {
      emit(SearchRestaurantError(message: e.toString()));
    }
  }

  void _onGetNearbyRestaurants(GetNearbyRestaurantEvent event,
      Emitter<SearchRestaurantState> emit) async {
    emit(SearchRestaurantLoading());
    try {
      final restaurants = await getNearbyRestaurantUsecase(
          NearbyRestaurantParams(
              latitude: event.latitude, longitude: event.longitude));
      if (state is! SearchRestaurantLoaded) {
        restaurants.fold(
            (l) => emit(SearchRestaurantError(message: l.errorMessage)),
            (r) => emit(SearchRestaurantLoaded(
                  restaurants: r,
                  isSearchEvent: false,
                )));
      }
    } catch (e) {
      if (state is! SearchRestaurantLoaded) {
        emit(SearchRestaurantError(message: e.toString()));
      }
    }
  }
}
