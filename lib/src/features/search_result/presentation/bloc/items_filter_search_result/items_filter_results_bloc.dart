import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_closest_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_highest_rated_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_most_popular_items_use_case.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_price_sorted_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_event.dart';

import './items_filter_results_state.dart';
import 'filter_item_result_params.dart';

class ItemsFilterSearchResultsBloc
    extends Bloc<ItemsFilterSearchResultsEvent, ItemsFilterSearchResultsState> {
  final GetHighestRatedItemsUseCase getHighestRatedItemsUseCase;
  final GetMostPopularItemsUseCase getMostPopularItemsUseCase;
  final GetPriceSortedItemsUseCase getPriceSortedItemsUseCase;
  final GetClosestItemsUseCase getClosestItemsUseCase;
  ItemsFilterSearchResultsBloc({
    required this.getHighestRatedItemsUseCase,
    required this.getMostPopularItemsUseCase,
    required this.getPriceSortedItemsUseCase,
    required this.getClosestItemsUseCase,
  }) : super(
          const FilterItemsLoading(
            selection: ItemsFilterState.highestRated,
            searchQuery: "",
            isFasting: false,
            category: 1,
            maximumPrice: 5000,
            rating: 3,
          ),
        ) {
    on<GetFilteredItemsEvent>(_getFilteredRestaurants);
    on<ResetItemsFilterSearchResultsEvent>((event, emit) {
      reset(emit);
    });
  }

  Future<void> _getFilteredRestaurants(GetFilteredItemsEvent event,
      Emitter<ItemsFilterSearchResultsState> emit) async {
    final filterItems = (state is FilterItemsSuccess)
        ? (state as FilterItemsSuccess).searchFilteredItems
        : [];
    if (event.page == 1) {
      emit(FilterItemsLoading(
        searchQuery: event.searchQuery,
        selection: event.selection,
        isFasting: event.isFasting,
        category: 1,
        location: event.location,
        rating: event.rating,
        maximumPrice: event.maximumPrice,
      ));
    } else {
      emit(
        FilterItemsNextLoading(
          searchFilteredItems: filterItems as List<ItemModel>,
          searchQuery: event.searchQuery,
          selection: event.selection,
          isFasting: event.isFasting,
          category: 1,
          location: event.location,
          rating: event.rating,
          maximumPrice: event.maximumPrice,
        ),
      );
    }

    Either<Failure, List<ItemModel>> itemResults;
    if (event.selection == ItemsFilterState.highestRated) {
      itemResults = await getHighestRatedItemsUseCase(
        FilterItemResultsParams(
          searchQuery: event.searchQuery,
          selection: event.selection,
          isFasting: event.isFasting,
          location: event.location,
          category: 1,
          rating: event.rating,
          maximumPrice: event.maximumPrice,
          page: event.page,
          limit: event.limit,
        ),
      );
    } else if (event.selection == ItemsFilterState.mostPopular) {
      itemResults = await getMostPopularItemsUseCase(
        FilterItemResultsParams(
          searchQuery: event.searchQuery,
          selection: event.selection,
          isFasting: event.isFasting,
          location: event.location,
          category: 1,
          rating: event.rating,
          maximumPrice: event.maximumPrice,
          page: event.page,
          limit: event.limit,
        ),
      );
    } else if (event.selection == ItemsFilterState.priceSorted) {
      itemResults = await getPriceSortedItemsUseCase(
        FilterItemResultsParams(
          searchQuery: event.searchQuery,
          selection: event.selection,
          isFasting: event.isFasting,
          location: event.location,
          category: 1,
          rating: event.rating,
          maximumPrice: event.maximumPrice,
          page: event.page,
          limit: event.limit,
        ),
      );
    } else {
      itemResults = await getClosestItemsUseCase(
        FilterItemResultsParams(
          searchQuery: event.searchQuery,
          selection: event.selection,
          isFasting: event.isFasting,
          location: event.location,
          category: 1,
          rating: event.rating,
          maximumPrice: event.maximumPrice,
          page: event.page,
          limit: event.limit,
        ),
      );
    }
    emit(
      itemResults.fold(
        (failure) {
          if (event.page == 1) {
            return FilterItemsFailure(
                searchQuery: state.searchQuery,
                selection: state.selection,
                isFasting: state.isFasting,
                location: state.location,
                category: state.category,
                rating: event.rating,
                maximumPrice: event.maximumPrice,
                message: failure.errorMessage);
          }
          return FilterItemsSuccess(
            status: false,
            searchFilteredItems: filterItems as List<ItemModel>,
            selection: state.selection,
            searchQuery: state.searchQuery,
            isFasting: state.isFasting,
            location: state.location,
            category: state.category,
            rating: event.rating,
            maximumPrice: event.maximumPrice,
          );
        },
        (success) {
          if (event.page != 1) {
            return FilterItemsSuccess(
              searchFilteredItems: List.of(filterItems as List<ItemModel>)
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
          return FilterItemsSuccess(
            searchFilteredItems: success,
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
        },
      ),
    );
  }

  void reset(Emitter emit) {
    emit(
      const FilterItemsInitial(
        selection: ItemsFilterState.highestRated,
        isFasting: false,
        searchQuery: '',
        location: null,
        category: 0,
        rating: 1,
        maximumPrice: 2000,
      ),
    );
  }
}
