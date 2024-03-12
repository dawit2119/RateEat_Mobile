import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_restaurant_items_use_case.dart';

import '../../../../../core/constants/app_states.dart';
import '../../../../restaurant_menu/domain/entities/entities.dart';
import '../../../data/datasources/local_restaurant_detail_data_provider.dart';

part 'restaurant_items_event.dart';
part 'restaurant_items_state.dart';

class RestaurantItemsBloc
    extends Bloc<RestaurantItemsEvent, RestaurantItemsState> {
  final GetRestaurantItemsUseCase getRestaurantItemsUseCase;

  RestaurantItemsBloc({
    required this.getRestaurantItemsUseCase,
  }) : super(GetRestaurantItemsState()) {
    RestaurantItemsState eitherRestaurantItemsOrError(
        Either<Failure, List<ItemModel>> failureOrRestaurantItems,
        GetRestaurantItemsState restaurantItemsState) {
      return failureOrRestaurantItems.fold(
        (error) => restaurantItemsState.copyWith(
            status: ItemStatus.error, errorMessage: "Error"),
        (items) => restaurantItemsState.copyWith(
            status: ItemStatus.loaded, items: items),
      );
    }

    RestaurantItemsState eitherNextRestaurantItemsOrError(
        Either<Failure, List<ItemModel>> failureOrNextRestaurantItems,
        GetRestaurantItemsState restaurantItemsState) {
      return failureOrNextRestaurantItems.fold(
        (error) => restaurantItemsState.copyWith(
            status: ItemStatus.nextError,
            errorMessage: "Error",
            items: restaurantItemsState.items),
        (items) => items.isEmpty
            ? restaurantItemsState.copyWith(
                status: ItemStatus.loaded, hasReachedMax: true)
            : restaurantItemsState.copyWith(
                status: ItemStatus.loaded,
                items:
                    List.of(restaurantItemsState.items as Iterable<ItemModel>)
                      ..addAll(items),
                hasReachedMax: false),
      );
    }

    void onGetRestaurantItems(
        GetRestaurantItems event, Emitter<RestaurantItemsState> emit) async {
      final restaurantItemsState = state as GetRestaurantItemsState;

      if (restaurantItemsState.hasReachedMax) return;
      // First Time Loading
      if (restaurantItemsState.status == ItemStatus.loading ||
          restaurantItemsState.status == ItemStatus.error) {
        emit(GetRestaurantItemsState());

        final failureOrRestaurantItems = await getRestaurantItemsUseCase(
            GetRestaurantItemsParams(
                page: event.page,
                limit: event.limit,
                restaurantId: event.restaurantId));

        debugPrint('failureOrRestaurantItems $failureOrRestaurantItems');

        failureOrRestaurantItems.fold(
          (failure) => emit(eitherRestaurantItemsOrError(
              failureOrRestaurantItems, restaurantItemsState)),
          (items) async {
            // Access the local data source using dpLocator
            final localDataSource = dpLocator<RestaurantLocalDataSource>();

            // Update cache
            await localDataSource.cacheRestaurantItems(
                event.restaurantId, items);
            if (!emit.isDone) {
              emit(eitherRestaurantItemsOrError(
                  Right(items), restaurantItemsState));
            }
          },
        );

        return;
      }

      // Get Next Top Rated
      final failureOrNextRestaurantItems = await getRestaurantItemsUseCase(
        GetRestaurantItemsParams(
            page: event.page,
            limit: event.limit,
            restaurantId: event.restaurantId),
      );

      debugPrint('failureOrNextRestaurantItems $failureOrNextRestaurantItems');

      failureOrNextRestaurantItems.fold(
        (failure) => emit(eitherNextRestaurantItemsOrError(
            failureOrNextRestaurantItems, restaurantItemsState)),
        (items) async {
          // Access the local data source using dpLocator
          final localDataSource = dpLocator<RestaurantLocalDataSource>();

          debugPrint('items in bloc right $items');
          // Update cache
          await localDataSource.cacheRestaurantItems(event.restaurantId, items);
          if (!emit.isDone) {
            emit(eitherNextRestaurantItemsOrError(
                Right(items), restaurantItemsState));
          }
        },
      );
    }

    on<GetRestaurantItems>(onGetRestaurantItems);
  }
}
