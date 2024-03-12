import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  final GetLocationUseCase getLocationUseCase;
  Timer? _timer;

  UserLocationBloc({required this.getLocationUseCase})
      : super(const UserLocationInitial()) {
    on<GetUserLocation>(_onGetUserLocation);
    on<ChangeUserLocation>(_onChangeCurrentLocation);

    // Start the timer when the bloc is initialized
    _startPeriodicLocationUpdates();
  }

  void _startPeriodicLocationUpdates() {
    _timer?.cancel();

    add(const GetUserLocation());
    debugPrint("==================== Refreshing location ====================");

    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      add(const GetUserLocation());
    });
  }

  FutureOr<void> _onGetUserLocation(
      GetUserLocation event, Emitter<UserLocationState> emit) async {
    emit(const UserLocationLoading());
    Either<Failure, Location> location = await getLocationUseCase(NoParams());
    emit(fromEither(location));
  }

  /// Handles changing the user location manually
  Future<void> _onChangeCurrentLocation(
      ChangeUserLocation event, Emitter<UserLocationState> emit) async {
    emit(UserLocationLoaded(location: event.newLocation));
  }

  UserLocationState fromEither(
      Either<Failure, Location> eitherFailureOrLocation) {
    return eitherFailureOrLocation.fold(
      (failure) => UserLocationError(message: failure.errorMessage),
      (userLocation) => UserLocationLoaded(location: userLocation),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
