import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/local_nearby_restaurant_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/nearby_usecase.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/nearby_rest_state.dart';
import 'package:rateeat_mobile/src/features/map_section/data/models/restaurant_model.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/entities/restaurant.dart';

class HomePageNearbyRestaurantBloc
    extends Bloc<HomePageNearbyRestEvent, HomePageNearbyRestaurantState> {
  final NearbyUseCase nearbyUseCase;
  Timer? _timer;

  HomePageNearbyRestaurantBloc({required this.nearbyUseCase})
      : super(NearbyLoading()) {
    on<GetNearByRestaurants>(_onGetNearByRestaurants);

    _startPeriodicRestaurantUpdates();
  }

  void _startPeriodicRestaurantUpdates() {
    _timer?.cancel();

    _fetchAndDispatchLocation();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _fetchAndDispatchLocation();
    });
  }

  Future<void> _fetchAndDispatchLocation() async {
    try {
      Position position = await _determinePosition();
      add(GetNearByRestaurants(
        lat: position.latitude,
        lng: position.longitude,
        tags: const [],
        page: 1,
        limit: 10,
      ));
    } catch (e) {
      add(GetNearByRestaurants(
        lat: 0.0,
        lng: 0.0,
        tags: const [],
        page: 1,
        limit: 10,
      ));
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<void> _onGetNearByRestaurants(GetNearByRestaurants event,
      Emitter<HomePageNearbyRestaurantState> emit) async {
    List<RestaurantModel> previouslyLoadedRestaurants =
        state is NearbyRestaurantFetched
            ? (state as NearbyRestaurantFetched).restaurants
            : [];
    int page = event.page == 1
        ? 1
        : (state is NearbyRestaurantFetched
            ? (state as NearbyRestaurantFetched).page
            : 1);

    if (event.page == 1) {
      emit(NearbyLoading());
    } else {
      emit(NearbyRestaurantNextLoading(
          restaurants: previouslyLoadedRestaurants, page: page));
    }

    final res = await nearbyUseCase.getNearbyRestaurants(
      event.lat,
      event.lng,
      event.tags,
      event.page,
      event.limit,
    );

    await res.fold(
      (err) async {
        final List<Restaurant> localRestaurants =
            await dpLocator<LocalNearbyRestaurantDataProvider>()
                .getNearbyRestaurants();

        if (localRestaurants.isNotEmpty && event.page == 1) {
          emit(NearbyRestaurantFetchedFromLocal(
            restaurants: localRestaurants
                .map((restaurant) => RestaurantModel.fromEntity(restaurant))
                .toList(),
          ));
        } else {
          emit(NearbyRestaurantFailure(
            err: err.errorMessage,
          ));
        }
      },
      (res) async {
        emit(NearbyRestaurantFetched(
          totalItems: res.totalItems,
          restaurants: event.page == 1
              ? res.restaurants
              : List<RestaurantModel>.from(previouslyLoadedRestaurants) +
                  res.restaurants,
          page: page + 1,
          hasReachedMax: res.restaurants.isEmpty,
        ));

        if (event.page == 1) {
          await dpLocator<LocalNearbyRestaurantDataProvider>()
              .clearNearbyRestaurants();
        }
        await dpLocator<LocalNearbyRestaurantDataProvider>()
            .cacheNearbyRestaurants(res.restaurants);
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
