import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_closest_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_highest_rated_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_most_popular_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_price_sorted_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';

class RestaurantsFilterSearchResultsBloc extends Bloc<
    RestaurantsFilterSearchResultsEvent, RestaurantsFilterSearchResultsState> {
  final GetMostPopularRestaurantsUseCase getMostPopularRestaurantsUseCase;
  final GetHighestRatedRestaurantsUseCase getHighestRatedRestaurantsUseCase;
  final GetPriceSortedRestaurantsUseCase getPriceSortedRestaurantsUseCase;
  final GetClosestRestaurantsUseCase getClosestRestaurantsUseCase;
  RestaurantsFilterSearchResultsBloc({
    required this.getMostPopularRestaurantsUseCase,
    required this.getClosestRestaurantsUseCase,
    required this.getHighestRatedRestaurantsUseCase,
    required this.getPriceSortedRestaurantsUseCase,
  }) : super(
          const FilterRestaurantsLoading(
            selection: RestaurantsFilterState.highestRated,
            isFasting: false,
            searchQuery: '',
            location: null,
            category: 0,
            rating: 1,
            maximumPrice: 2000,
          ),
        ) {
    on<GetFilteredRestaurantEvent>(_getFilteredRestaurants);
  }

  Future<void> _getFilteredRestaurants(GetFilteredRestaurantEvent event,
      Emitter<RestaurantsFilterSearchResultsState> emit) async {
    final filterRestaurant = (state is FilterRestaurantsSuccess)
        ? (state as FilterRestaurantsSuccess).searchFilteredRestaurants
        : [];
    if (event.category == 0) {
      if (event.page == 1) {
        emit(FilterRestaurantsLoading(
          searchQuery: event.searchQuery,
          selection: event.selection,
          isFasting: event.isFasting,
          category: event.category,
          location: event.location,
          rating: event.rating,
          maximumPrice: event.maximumPrice,
        ));
      } else {
        emit(FilterRestaurantsNextLoading(
          searchFilteredRestaurants: filterRestaurant as List<Restaurant>,
          searchQuery: event.searchQuery,
          selection: event.selection,
          isFasting: event.isFasting,
          category: event.category,
          location: event.location,
          rating: event.rating,
          maximumPrice: event.maximumPrice,
        ));
      }
    }

    if (event.category == 0) {
      Either<Failure, List<Restaurant>> restaurantResults;
      if (event.selection == RestaurantsFilterState.closest) {
        restaurantResults = await getClosestRestaurantsUseCase(
          FilterRestaurantResultsParams(
            searchQuery: event.searchQuery,
            selection: event.selection,
            isFasting: event.isFasting,
            location: event.location,
            category: event.category,
            rating: event.rating,
            maximumPrice: event.maximumPrice,
            page: event.page,
            limit: event.limit,
          ),
        );
      } else if (event.selection == RestaurantsFilterState.highestRated) {
        restaurantResults = await getHighestRatedRestaurantsUseCase(
          FilterRestaurantResultsParams(
            searchQuery: event.searchQuery,
            selection: event.selection,
            isFasting: event.isFasting,
            location: event.location,
            category: event.category,
            rating: event.rating,
            maximumPrice: event.maximumPrice,
            page: event.page,
            limit: event.limit,
          ),
        );
      } else if (event.selection == RestaurantsFilterState.priceSorted) {
        restaurantResults = await getPriceSortedRestaurantsUseCase(
          FilterRestaurantResultsParams(
            searchQuery: event.searchQuery,
            selection: event.selection,
            isFasting: event.isFasting,
            location: event.location,
            category: event.category,
            rating: event.rating,
            maximumPrice: event.maximumPrice,
            page: event.page,
            limit: event.limit,
          ),
        );
      } else {
        restaurantResults = await getMostPopularRestaurantsUseCase(
          FilterRestaurantResultsParams(
            searchQuery: event.searchQuery,
            selection: event.selection,
            isFasting: event.isFasting,
            location: event.location,
            category: event.category,
            rating: event.rating,
            maximumPrice: event.maximumPrice,
            page: event.page,
            limit: event.limit,
          ),
        );
      }

      emit(
        restaurantResults.fold((failure) {
          if (event.page == 1) {
            return FilterRestaurantsFailure(
                searchQuery: state.searchQuery,
                selection: state.selection,
                location: state.location,
                isFasting: state.isFasting,
                category: state.category,
                rating: event.rating,
                maximumPrice: event.maximumPrice,
                message: failure.errorMessage);
          }
          return FilterRestaurantsSuccess(
            status: false,
            searchFilteredRestaurants: filterRestaurant as List<Restaurant>,
            selection: state.selection,
            searchQuery: state.searchQuery,
            isFasting: state.isFasting,
            location: state.location,
            category: state.category,
            rating: event.rating,
            maximumPrice: event.maximumPrice,
          );
        }, (success) {
          if (event.page != 1) {
            return FilterRestaurantsSuccess(
              searchFilteredRestaurants:
                  List.of(filterRestaurant as List<Restaurant>)
                    ..addAll(success),
              selection: state.selection,
              searchQuery: state.searchQuery,
              isFasting: state.isFasting,
              location: state.location,
              category: state.category,
              rating: event.rating,
              maximumPrice: event.maximumPrice,
              hasReachedMax: success.isEmpty,
              status: true,
            );
          }
          return FilterRestaurantsSuccess(
              searchFilteredRestaurants: success,
              selection: state.selection,
              searchQuery: state.searchQuery,
              isFasting: state.isFasting,
              location: state.location,
              category: state.category,
              rating: event.rating,
              maximumPrice: event.maximumPrice,
              hasReachedMax: false,
              status: true);
        }),
      );
    }
  }
}

class FilterRestaurantResultsParams {
  final String searchQuery;
  final RestaurantsFilterState selection;
  final Location location;
  final bool isFasting;
  final int category;
  final double rating;
  final int maximumPrice;
  final int page;
  final int limit;
  FilterRestaurantResultsParams({
    required this.searchQuery,
    required this.selection,
    required this.isFasting,
    required this.location,
    required this.category,
    required this.rating,
    required this.maximumPrice,
    required this.page,
    required this.limit,
  });
}
