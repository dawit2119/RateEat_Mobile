import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../features.dart';
import '../../domain/domain.dart';

class AllRestaurantsBloc
    extends Bloc<AllRestaurantsEvent, AllRestaurantsState> {
  final MapFunctionRepo mapFunctionRepo;
  Timer? _timer;

  AllRestaurantsBloc({required this.mapFunctionRepo})
      : super(AllRestaurantsInitial()) {
    on<GetAllRestaurants>(_fetchAllRestaurants);
    on<ResetAllRestaurantsEvent>((event, emit) {
      emit(AllRestaurantsInitial());
    });

    // Start the timer to fetch restaurants every 2 minutes
    _startPeriodicRestaurantUpdates();
  }

  /// Starts a timer to fetch all restaurants every 2 minutes
  void _startPeriodicRestaurantUpdates() {
    _timer?.cancel(); // Cancel any existing timer to avoid duplication

    // Fetch restaurants immediately and then every 2 minutes
    _fetchAndDispatchLocation();
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _fetchAndDispatchLocation();
    });
  }

  /// Fetch the current location and dispatch the event
  Future<void> _fetchAndDispatchLocation() async {
    try {
      Position position = await _determinePosition();
      double radius = 5000; // Set a realistic default radius, e.g., 5000 meters

      add(GetAllRestaurants(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: radius,
      ));
    } catch (e) {
      // Handle error: if location can't be determined, emit a failure state
      add(GetAllRestaurants(
        latitude: 0.0,
        longitude: 0.0,
        radius: 5000,
      ));
    }
  }

  /// Determine the current position of the device
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
        accuracy: LocationAccuracy.best,
      ),
    );
  }

  /// Fetch all restaurants from the repository
  FutureOr<void> _fetchAllRestaurants(
    GetAllRestaurants event,
    Emitter<AllRestaurantsState> emit,
  ) async {
    emit(AllRestaurantsLoading());
    final allRestaurants = await mapFunctionRepo.fetchAllRestaurants(
      limit: event.limit,
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
    );
    allRestaurants.fold(
      (failure) => emit(AllRestaurantsFailure(message: failure.errorMessage)),
      (success) =>
          emit(AllRestaurantsSuccess(restaurants: success.restaurants)),
    );
  }

  /// Clean up the timer when the bloc is closed
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

// Event
abstract class AllRestaurantsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAllRestaurants extends AllRestaurantsEvent {
  final int limit;
  final double latitude;
  final double longitude;
  final double radius;

  GetAllRestaurants({
    this.limit = 100,
    required this.radius,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude, radius];
}

class ResetAllRestaurantsEvent extends AllRestaurantsEvent {
  @override
  List<Object> get props => [];
}

// State
abstract class AllRestaurantsState extends Equatable {
  @override
  List<Object> get props => [];
}

class AllRestaurantsInitial extends AllRestaurantsState {}

class AllRestaurantsLoading extends AllRestaurantsState {}

class AllRestaurantsSuccess extends AllRestaurantsState {
  final List<Restaurant> restaurants;

  AllRestaurantsSuccess({required this.restaurants});
}

class AllRestaurantsFailure extends AllRestaurantsState {
  final String message;

  AllRestaurantsFailure({required this.message});
}
