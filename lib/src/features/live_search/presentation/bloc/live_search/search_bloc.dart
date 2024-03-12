import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/use_cases.dart';

import './search_event.dart';
import './search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final LiveSearchRestaurantsUseCase liveSearchRestaurantsUseCase;
  final LiveSearchItemsUseCase liveSearchItemsUseCase;
  SearchBloc({
    required this.liveSearchRestaurantsUseCase,
    required this.liveSearchItemsUseCase,
  }) : super(SearchInitial()) {
    on<TriggerInitial>(
      (event, emit) => emit(
        SearchInitial(),
      ),
    );
    on<RestaurantSearchEvent>(
      (event, emit) async {
        emit(SearchLoading());
        try {
          final result = await liveSearchRestaurantsUseCase(
            event.query,
          );
          result.fold(
            (l) => emit(
              SearchError(error: "Unable to get restaurants"),
            ),
            (results) => emit(
              RestaurantSearchLoaded(results: results),
            ),
          );
        } catch (e) {
          emit(SearchError(error: e.toString()));
        }
      },
    );

    on<ItemSearchEvent>(
      (event, emit) async {
        emit(SearchLoading());
        try {
          final result = await liveSearchItemsUseCase(
            LiveSearchItemsUseCaseParams(
              searchTerm: event.query,
              latitude: event.latitude,
              longitude: event.longitude,
            ),
          );
          result.fold(
            (error) => emit(
              SearchError(
                error: "Unable to get items",
              ),
            ),
            (results) => emit(
              ItemSearchLoaded(results: results),
            ),
          );
        } catch (e) {
          emit(
            SearchError(
              error: e.toString(),
            ),
          );
        }
      },
    );
  }
}
