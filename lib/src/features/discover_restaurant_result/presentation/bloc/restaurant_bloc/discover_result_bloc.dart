import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';
import '../../../domain/use_cases/discover_restaurant_use_case.dart';
import 'discover_result_event.dart';
import 'discover_result_state.dart';

class FetchDiscoverRestaurantResultBloc extends Bloc<
    FetchDiscoverRestaurantResultEvent, FetchDiscoverRestaurantResultState> {
  FetchDiscoverRestaurantResultBloc({required this.discoverRestaurantUseCase})
      : super(DiscoverRestaurantInitial()) {
    on<FetchNewDiscoverRestaurantResultEvent>(_onResetDiscoverRestaurantResult);
    on<LoadMoreDiscoverRestaurantResultEvent>(
        _onLoadMoreDiscoverRestaurantResult);
  }
  final DiscoverRestaurantUseCase discoverRestaurantUseCase;

  _onLoadMoreDiscoverRestaurantResult(
      LoadMoreDiscoverRestaurantResultEvent event,
      Emitter<FetchDiscoverRestaurantResultState> emit) async {
    final List<DiscoverRestaurantResultModel> previouslyLoadedResults =
        state is DiscoverRestaurantLoaded
            ? (state as DiscoverRestaurantLoaded).discoveredRestaurantResults
            : [];
    final page = event.discoveryStepsBloc.state.discoverRestaurantProps.page;
    if (page == 1) {
      emit(
        DiscoverRestaurantLoading(),
      );
    } else {
      emit(
        DiscoverRestaurantsNextLoading(
          discoveredRestaurantResults: previouslyLoadedResults,
        ),
      );
    }

    try {
      var result = await discoverRestaurantUseCase(DiscoverRestaurantParams(
        fasting:
            event.discoveryStepsBloc.state.discoverRestaurantProps.fasting ??
                false,
        latitude:
            event.discoveryStepsBloc.state.discoverRestaurantProps.latitude!,
        longitude:
            event.discoveryStepsBloc.state.discoverRestaurantProps.longitude!,
        radius: event.discoveryStepsBloc.state.discoverRestaurantProps
                .distanceToTravel ??
            1000,
        maxPrice:
            event.discoveryStepsBloc.state.discoverRestaurantProps.maxPrice ??
                5000,
        minRating:
            event.discoveryStepsBloc.state.discoverRestaurantProps.minRating ??
                0,
        tags:
            event.discoveryStepsBloc.state.discoverRestaurantProps.tags ?? [""],
        sorting:
            event.discoveryStepsBloc.state.discoverRestaurantProps.sorting ??
                "rating",
        limit: 10,
        page: page,
        maxTravelTime: event
            .discoveryStepsBloc.state.discoverRestaurantProps.maxTravelTime,
        transportMode: event
            .discoveryStepsBloc.state.discoverRestaurantProps.transportMode,
      ));
      result.fold(
        (failure) => page == 1
            ? emit(
                DiscoverRestaurantError(errorMessage: failure.errorMessage),
              )
            : emit(
                DiscoverRestaurantLoaded(
                  discoveredRestaurantResults: previouslyLoadedResults,
                  searchLoadingStatus: false,
                ),
              ),
        (searchResults) => emit(
          DiscoverRestaurantLoaded(
            discoveredRestaurantResults: previouslyLoadedResults
              ..addAll(
                searchResults,
              ),
            hasReachedMax: searchResults.isEmpty,
          ),
        ),
      );
    } catch (e) {
      emit(
        DiscoverRestaurantError(errorMessage: e.toString()),
      );
    }
  }

  _onResetDiscoverRestaurantResult(FetchNewDiscoverRestaurantResultEvent event,
      Emitter<FetchDiscoverRestaurantResultState> emit) async {
    final List<DiscoverRestaurantResultModel> previouslyLoadedResults =
        state is DiscoverRestaurantLoaded
            ? (state as DiscoverRestaurantLoaded).discoveredRestaurantResults
            : [];
    final page = event.discoveryStepsBloc.state.discoverRestaurantProps.page;
    if (page == 1) {
      emit(
        DiscoverRestaurantLoading(),
      );
    } else {
      emit(
        DiscoverRestaurantsNextLoading(
          discoveredRestaurantResults: previouslyLoadedResults,
        ),
      );
    }

    try {
      var result = await discoverRestaurantUseCase(DiscoverRestaurantParams(
        fasting:
            event.discoveryStepsBloc.state.discoverRestaurantProps.fasting ??
                false,
        latitude:
            event.discoveryStepsBloc.state.discoverRestaurantProps.latitude!,
        longitude:
            event.discoveryStepsBloc.state.discoverRestaurantProps.longitude!,
        radius: event.discoveryStepsBloc.state.discoverRestaurantProps
                .distanceToTravel ??
            1000,
        maxPrice:
            event.discoveryStepsBloc.state.discoverRestaurantProps.maxPrice ??
                5000,
        minRating:
            event.discoveryStepsBloc.state.discoverRestaurantProps.minRating ??
                0,
        tags:
            event.discoveryStepsBloc.state.discoverRestaurantProps.tags ?? [""],
        sorting:
            event.discoveryStepsBloc.state.discoverRestaurantProps.sorting ??
                "rating",
        limit: 10,
        page: page,
        maxTravelTime: event
            .discoveryStepsBloc.state.discoverRestaurantProps.maxTravelTime,
        transportMode: event
            .discoveryStepsBloc.state.discoverRestaurantProps.transportMode,
      ));
      result.fold(
        (failure) =>
            emit(DiscoverRestaurantError(errorMessage: failure.errorMessage)),
        (searchResults) => emit(
          DiscoverRestaurantLoaded(discoveredRestaurantResults: searchResults),
        ),
      );
    } catch (e) {
      emit(
        DiscoverRestaurantError(errorMessage: e.toString()),
      );
    }
  }
}
