import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_restaurant_popular_reviews_usecase.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/local_restaurant_detail_data_provider.dart';

part 'restaurant_popular_reviews_event.dart';
part 'restaurant_popular_reviews_state.dart';

class RestaurantPopularReviewsBloc
    extends Bloc<RestaurantPopularReviewsEvent, RestaurantPopularReviewsState> {
  final GetPopularRestaurantReviewsUseCase getPopularRestaurantReviews;

  RestaurantPopularReviewsBloc({required this.getPopularRestaurantReviews})
      : super(PopularRestaurantReviewsInitial()) {
    on<GetRestaurantPopularReviewsEvent>(_onPopularRestaurantReviews);
  }

  //* Get Restaurant popular reviews
  void _onPopularRestaurantReviews(GetRestaurantPopularReviewsEvent event,
      Emitter<RestaurantPopularReviewsState> emit) async {
    emit(PopularRestaurantReviewsLoading());
    try {
      // Access the local data source using dpLocator
      final localDataSource = dpLocator<RestaurantLocalDataSource>();

      // Fetch from network
      final failureOrPopular = await getPopularRestaurantReviews(
        GetRestaurantPopularReviewsParams(
          restaurantId: event.restaurantId,
        ),
      );

      await failureOrPopular.fold(
        (failure) async {
          // On network error, try fetching from cache
          final cachedReviews =
              await localDataSource.getCachedPopularReviews(event.restaurantId);

          if (cachedReviews != null) {
            emit(PopularRestaurantReviewsLoaded(popularReviews: cachedReviews));
          } else {
            emit(PopularRestaurantReviewsFailure(
              message: failure.errorMessage,
            ));
          }
        },
        (popularReviews) async {
          // Cache successful network response
          await localDataSource.cachePopularReviews(
              event.restaurantId, popularReviews);
          emit(PopularRestaurantReviewsLoaded(popularReviews: popularReviews));
        },
      );
    } catch (e) {
      emit(PopularRestaurantReviewsFailure(message: 'Server Error'));
    }
  }

  // RestaurantPopularReviewsState _eitherPopularOrFailure(
  //     Either<Failure, PopularRestaurantReviewsResponse> failureOrPopular) {
  //   return failureOrPopular.fold(
  //     (error) => PopularRestaurantReviewsFailure(message: error.errorMessage),
  //     (success) => PopularRestaurantReviewsLoaded(popularReviews: success),
  //   );
  // }
}
