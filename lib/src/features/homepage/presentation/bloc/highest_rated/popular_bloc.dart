import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/highest_rated/popular_event.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/highest_rated/popular_state.dart';

import '../../../data/datasource/local_homepage_dataprovider.dart';
import '../../../domain/entities/item.dart';
import 'dart:async';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final GetPopularUseCase getPopularUseCase;

  PopularBloc({required this.getPopularUseCase})
      : super(const TopRatedState()) {
    on<GetTopRatedEvent>(_onGetTopRated);
    on<ResetTopRatedEvent>((event, emit) {
      reset(emit);
    });
  }

  Future<void> _onGetTopRated(
      GetTopRatedEvent event, Emitter<PopularState> emit) async {
    final currentState = state as TopRatedState;

    if (currentState.hasReachedMax && event.page > 1) return;

    // Emit loading state only for the first page
    if (event.page == 1) {
      emit(const TopRatedState(status: ItemStatus.loading));
    }

    final failureOrTopRated = await getPopularUseCase(
      GetPopularItemsParams(
        page: event.page,
        limit: event.limit,
        lat: event.lat,
        lng: event.lng,
        tags: event.tags,
        isFasting: event.isFasting,
      ),
    );

    // Handle the response for both initial load and pagination
    await failureOrTopRated.fold(
      (error) async {
        final localItems =
            await dpLocator<LocalHomepageDataprovider>().getTopRatedItems();

        if (error is NetworkFailure && localItems.isNotEmpty) {
          emit(currentState.copyWith(
            popular: localItems,
            totalItems: localItems.length,
            status: ItemStatus.loaded,
            hasReachedMax: true,
            errorMessage: "Fetched from local storage",
          ));
        } else {
          emit(currentState.copyWith(
            status: ItemStatus.error,
            errorMessage: "Error loading items",
          ));
        }
      },
      (topRated) async {
        // Emit loaded state for the first page or append items for pagination
        emit(_getUpdatedStateWithNewItems(
            currentState, topRated.items, event.page, topRated.totalItems));

        // Cache data on success
        if (event.page == 1) {
          await dpLocator<LocalHomepageDataprovider>().clearTopRatedItems();
        }
        await dpLocator<LocalHomepageDataprovider>()
            .cacheTopRatedItems(topRated.items);
      },
    );
  }

  // Helper method to update the state with new items
  TopRatedState _getUpdatedStateWithNewItems(TopRatedState currentState,
      List<Item> newItems, int page, int? totalItems) {
    final hasReachedMax = newItems.isEmpty;
    if (page == 1) {
      return currentState.copyWith(
        status: ItemStatus.loaded,
        hasReachedMax: hasReachedMax,
        totalItems: totalItems,
        popular: newItems,
      );
    }

    final List<Item> updatedPopular = List.of(currentState.popular ?? [])
      ..addAll(newItems);
    return currentState.copyWith(
      status: ItemStatus.loaded,
      popular: updatedPopular,
      hasReachedMax: hasReachedMax,
      totalItems: totalItems,
    );
  }

  void reset(Emitter emit) {
    emit(const TopRatedState(status: ItemStatus.loading));
  }
}
