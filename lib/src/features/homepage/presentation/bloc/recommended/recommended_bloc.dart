import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

part 'recommended_event.dart';
part 'recommended_state.dart';

class RecommendedBloc extends Bloc<RecommendedEvent, RecommendedState> {
  final GetRestaurantRecommendationsUseCase getRecommendedUseCase;

  RecommendedBloc({required this.getRecommendedUseCase})
      : super(RecommendedRestaurantLoading()) {
    on<GetRecommendedEvent>(_onGetRecommendation);
  }

  void _onGetRecommendation(
      GetRecommendedEvent event, Emitter<RecommendedState> emit) async {
    List<RecommendedRestaurantEntity> previouslyLoadedRestaurants =
        state is RecommendedRestaurantFetched
            ? (state as RecommendedRestaurantFetched).restaurants
            : [];
    int page = state is RecommendedRestaurantFetched
        ? (state as RecommendedRestaurantFetched).page
        : 1;

    if (event.page == 1) {
      emit(RecommendedRestaurantLoading());
    } else {
      emit(
        RecommendedRestaurantNextLoading(
          restaurants: previouslyLoadedRestaurants,
          page: page,
        ),
      );
    }
    final response = await getRecommendedUseCase(
      GetRecommendedRestaurantsParams(
        page: event.page,
        limit: event.limit,
        latitude: event.latitude,
        longitude: event.longitude,
        tags: event.tags,
      ),
    );

    response.fold((error) {
      if (event.page == 1) {
        emit(
          RecommendedRestaurantFailure(
            errorMessage: error.errorMessage,
          ),
        );
      } else {
        emit(
          RecommendedRestaurantFetched(
            restaurants: previouslyLoadedRestaurants,
            page: page,
          ),
        );
      }
    }, (restaurants) {
      if (event.page == 1) {
        emit(
          RecommendedRestaurantFetched(
            restaurants: restaurants,
            page: 2,
          ),
        );
      } else {
        emit(
          RecommendedRestaurantFetched(
            restaurants: previouslyLoadedRestaurants
              ..addAll(
                restaurants,
              ),
            hasReachedMax: restaurants.isEmpty,
            page: page + 1,
          ),
        );
      }
    });
  }
}
