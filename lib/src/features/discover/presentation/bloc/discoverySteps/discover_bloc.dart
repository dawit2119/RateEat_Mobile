import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/discover/data/models/discover_restaurant_model.dart';
import 'discover_restaurants_event.dart';
import 'discover_restaurants_state.dart';

class DiscoveryStepsBloc extends Bloc<DiscoverEvent, DiscoverRestaurantState> {
  DiscoveryStepsBloc()
      : super(const DiscoverRestaurantState(
          discoverRestaurantProps: DiscoverRestaurantModel(),
        )) {
    on<DiscoveryFilterUpdate>(_onFilterChanged);
    on<StartDiscoverFlowEvent>(_onStartFlow);
  }

  _onFilterChanged(DiscoveryFilterUpdate event,
      Emitter<DiscoverRestaurantState> emit) async {
    var newState = state.discoverRestaurantProps.copyWith(
      tags: event.tags ?? state.discoverRestaurantProps.tags,
      distanceToTravel: event.distanceToTravel ??
          state.discoverRestaurantProps.distanceToTravel,
      latitude: event.latitude ?? state.discoverRestaurantProps.latitude,
      longitude: event.longitude ?? state.discoverRestaurantProps.longitude,
      maxPrice: event.maxPrice ?? state.discoverRestaurantProps.maxPrice,
      minPrice: event.minPrice ?? state.discoverRestaurantProps.minPrice,
      minRating: event.minRating ?? state.discoverRestaurantProps.minRating,
      fasting: event.fasting ?? state.discoverRestaurantProps.fasting,
      searchQuery:
          event.searchQuery ?? state.discoverRestaurantProps.searchQuery,
      sorting: event.sorting ?? state.discoverRestaurantProps.sorting,
      page: event.page,
      maxTravelTime:
          event.maxTravelTime ?? state.discoverRestaurantProps.maxTravelTime,
      transportMode:
          event.transportMode ?? state.discoverRestaurantProps.transportMode,
    );
    emit(
      DiscoverRestaurantState(
        discoverRestaurantProps: newState,
      ),
    );
  }

  _onStartFlow(StartDiscoverFlowEvent event,
      Emitter<DiscoverRestaurantState> emit) async {
    emit(const DiscoverRestaurantState(
      discoverRestaurantProps: DiscoverRestaurantModel(),
    ));
  }
}
