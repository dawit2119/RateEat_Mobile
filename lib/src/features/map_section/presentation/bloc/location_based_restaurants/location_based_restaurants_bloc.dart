import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/use_cases/get_location_based_restaurants_usecase.dart';

part 'location_based_restaurants_event.dart';
part 'location_based_restaurants_state.dart';

class LocationBasedRestaurantsBloc
    extends Bloc<LocationBasedRestaurantsEvent, LocationBasedRestaurantsState> {
  final LocationBasedRestaurantUseCase searchRestaurantsCountUseCase;
  LocationBasedRestaurantsBloc({
    required this.searchRestaurantsCountUseCase,
  }) : super(LocationBasedRestaurantsInitial()) {
    on<GetRestaurantsCountEvent>(_onSearchRestaurants);
  }

  void _onSearchRestaurants(GetRestaurantsCountEvent event,
      Emitter<LocationBasedRestaurantsState> emit) async {
    emit(GetLocationBasedRestaurants(status: RestaurantStatus.loading));

    final failureOrRestaurantCount = await searchRestaurantsCountUseCase(
        LocationBasedRestaurantParams(
            lat: event.lat, long: event.long, radius: event.radius));

    emit(_eitherRestaurantCountOrError(failureOrRestaurantCount));
  }

  LocationBasedRestaurantsState _eitherRestaurantCountOrError(
      Either<Failure, int> failureOrRestaurantCount) {
    return failureOrRestaurantCount.fold(
      (error) => GetLocationBasedRestaurants(
          status: RestaurantStatus.error, errorMessage: "Error"),
      (count) => GetLocationBasedRestaurants(
          status: RestaurantStatus.loaded, count: count),
    );
  }
}
