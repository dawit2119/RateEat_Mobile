import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/restaurant_detail_usecase.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_event.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_state.dart';

import '../../../../../core/dp_injection/dependency_injection.dart';
import '../../../data/datasources/local_restaurant_detail_data_provider.dart';

class RestaurantDetailBloc
    extends Bloc<RestaurantDetailEvent, RestaurantDetailState> {
  final RestaurantDetailUseCase restaurantUseCase;

  RestaurantDetailBloc({
    required this.restaurantUseCase,
  }) : super(RestaurantDetailInitial()) {
    on<GetRestaurantDetailEvent>(
      (event, emit) async {
        emit(RestaurantDetailLoading());

        try {
          // Fetch restaurant details from the use case (API call)
          final restaurant = await restaurantUseCase(
            GetRestaurantDetailParams(
              restaurantId: event.restaurantId,
              latitude: event.latitude,
              longitude: event.longitude,
            ),
          );

          debugPrint('restaurant response in bloc $restaurant');

          // Process the result
          await restaurant.fold(
            (failure) async {
              // Attempt to fetch cached restaurant details from local storage
              debugPrint('restaurant bloc in the left failure $failure');
              final cachedRestaurant =
                  await dpLocator<RestaurantLocalDataSource>()
                      .getCachedRestaurantDetail(event.restaurantId);

              debugPrint("restaurant cachedRestaurant left: $cachedRestaurant");

              if (cachedRestaurant != null) {
                emit(RestaurantDetailSuccess(
                  restaurant: cachedRestaurant,
                ));
              } else {
                emit(RestaurantDetailError(error: failure.errorMessage));
              }
            },
            (restaurant) async {
              // Successfully fetched data, cache it locally
              debugPrint('restaurant bloc in the right $restaurant');
              await dpLocator<RestaurantLocalDataSource>()
                  .cacheRestaurantDetail(restaurant);

              emit(RestaurantDetailSuccess(restaurant: restaurant));
            },
          );
        } catch (e) {
          debugPrint('restaurant bloc error $e');
          // Handle unexpected errors
          final cachedRestaurant = await dpLocator<RestaurantLocalDataSource>()
              .getCachedRestaurantDetail(event.restaurantId);

          if (cachedRestaurant != null) {
            emit(RestaurantDetailSuccess(
              restaurant: cachedRestaurant,
            ));
          } else {
            emit(RestaurantDetailError(error: e.toString()));
          }
        }
      },
    );
  }
}
