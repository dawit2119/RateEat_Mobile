import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/nearby_restaurant_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/usecases/get_nearby_restaurants_usecase.dart';

part 'nearby_restaurant_event.dart';
part 'nearby_restaurant_state.dart';

class NearByRestaurantBloc
    extends Bloc<NearbyRestaurantEvent, NearByRestaurantState> {
  final GetNearByRestaurantsUseCase getNearByRestaurantsUseCase;

  NearByRestaurantBloc({required this.getNearByRestaurantsUseCase})
      : super(const NearbyRestaurantInitial(searchQuery: '')) {
    on<GetNearbyRestaurantEvent>(_getNearByRestaurants);
  }
  Future<void> _getNearByRestaurants(GetNearbyRestaurantEvent event,
      Emitter<NearByRestaurantState> emit) async {
    //* Get Restaurants
    final List<NearByRestaurantResponse> prevNearByRestaurants =
        (state is NearbyRestaurantLoaded)
            ? (state as NearbyRestaurantLoaded).nearbyRestaurants
            : [];

    //* Check if it's first page or next page
    if (event.page == 1) {
      emit(NearbyRestaurantLoading(searchQuery: state.searchQuery));
    } else {
      emit(
        NearbyRestaurantNextLoaded(
            nearbyRestaurants: prevNearByRestaurants,
            searchQuery: state.searchQuery),
      );
    }

    Either<Failure, List<NearByRestaurantResponse>> nearByRestaurants;
    nearByRestaurants =
        await getNearByRestaurantsUseCase(GetNearByRestaurantsParams(
      nearByRestaurantRequestModel: NearByRestaurantRequestModel(
        latitude: event.latitude,
        longitude: event.longitude,
        radius: event.radius,
        page: event.page,
        searchQuery: event.searchQuery,
        limit: event.limit,
      ),
    ));

    //* Emit the response
    emit(
      nearByRestaurants.fold((failure) {
        //* First page error message
        if (event.page == 1) {
          return NearbyRestaurantFailure(
              message: failure.errorMessage, searchQuery: state.searchQuery);
        }
        //* Second page error message
        return NearbyRestaurantLoaded(
          status: false,
          nearbyRestaurants: prevNearByRestaurants,
          searchQuery: state.searchQuery,
        );
      }, (success) {
        //* page different from first page
        if (event.page != 1) {
          return NearbyRestaurantLoaded(
            status: true,
            searchQuery: state.searchQuery,
            hasReachedMax: success.isEmpty,
            nearbyRestaurants: List.of(prevNearByRestaurants)..addAll(success),
          );
        }
        //* first page Success
        return NearbyRestaurantLoaded(
          status: true,
          hasReachedMax: false,
          nearbyRestaurants: success,
          searchQuery: state.searchQuery,
        );
      }),
    );
  }
}
