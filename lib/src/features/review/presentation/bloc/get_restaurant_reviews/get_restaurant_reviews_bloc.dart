import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_restaurant_reviews_by_popularity_usecase.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_restaurant_reviews_by_time_usecase.dart';

part 'get_restaurant_reviews_event.dart';
part 'get_restaurant_reviews_state.dart';

class GetRestaurantReviewsBloc
    extends Bloc<GetRestaurantReviewsEvent, GetRestaurantReviewsState> {
  final GetRestaurantReviewsByPopularityUseCase
      getPopularRestaurantReviewsUseCase;
  final GetRestaurantReviewsByTimeUseCase getRecentRestaurantReviewsUseCase;

  GetRestaurantReviewsBloc(
      {required this.getPopularRestaurantReviewsUseCase,
      required this.getRecentRestaurantReviewsUseCase})
      : super(const GetRestaurantReviewsInitial(
            sortType: RestaurantReviewsSortTypesState.mostRecent)) {
    on<GetRestaurantReviewsRequestEvent>(_getAllRestaurantReviews);
    on<ResetRestaurantReviewsRequestEvent>((event, emit) {
      reset(emit);
    });
  }

  Future<void> _getAllRestaurantReviews(GetRestaurantReviewsRequestEvent event,
      Emitter<GetRestaurantReviewsState> emit) async {
    //* get previous review
    final prevRestaurantReviews = (state is GetRestaurantReviewsLoaded)
        ? (state as GetRestaurantReviewsLoaded).reviews
        : RestaurantReviewsResponse(
            reviews: [],
            ratingsCount: [0, 0, 0, 0, 0],
            averageRating: 0.0,
            numberOfReviews: 0,
          );

    //* Check if it's first page or next page
    if (event.page == 1) {
      emit(GetRestaurantReviewsLoading(sortType: state.sortType));
    } else {
      emit(GetRestaurantReviewsNextLoading(
          reviews: prevRestaurantReviews, sortType: state.sortType));
    }

    Either<Failure, RestaurantReviewsResponse> restaurantReviews;
    if (event.sortType == RestaurantReviewsSortTypesState.mostRecent) {
      //* Get the most Recent Reviews
      restaurantReviews = await getRecentRestaurantReviewsUseCase(
        GetRecentRestaurantReviewsParams(
          restaurantId: event.restaurantId,
          page: event.page,
          limit: event.limit,
        ),
      );
    } else {
      //* Get the most Popular Reviews
      restaurantReviews = await getPopularRestaurantReviewsUseCase(
        GetPopularRestaurantReviewsParams(
          restaurantId: event.restaurantId,
          page: event.page,
          limit: event.limit,
        ),
      );
    }

    //* Emit the response
    emit(
      restaurantReviews.fold((failure) {
        //* First page error message
        if (event.page == 1) {
          return GetRestaurantReviewsFailure(
            message: failure.errorMessage,
            sortType: event.sortType,
          );
        }
        //* Second page error message
        return GetRestaurantReviewsLoaded(
          status: false,
          reviews: prevRestaurantReviews,
          sortType: event.sortType,
        );
      }, (success) {
        //* page different from first page
        if (event.page != 1) {
          final reviews = prevRestaurantReviews.reviews;
          final mergedReviews = List.of(reviews)..addAll(success.reviews);

          return GetRestaurantReviewsLoaded(
            reviews: prevRestaurantReviews.copyWith(reviews: mergedReviews),
            hasReachedMax: success.reviews.isEmpty,
            sortType: event.sortType,
          );
        }
        //* first page Success
        return GetRestaurantReviewsLoaded(
          reviews: success,
          hasReachedMax: false,
          sortType: event.sortType,
        );
      }),
    );
  }

  void reset(Emitter emit) {
    emit(
      const GetRestaurantReviewsInitial(
        sortType: RestaurantReviewsSortTypesState.mostRecent,
      ),
    );
  }
}
