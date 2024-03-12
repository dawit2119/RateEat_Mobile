import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_items/restaurant_items_bloc.dart';
import '../../../domain/use_cases/get_popular_items_usecase.dart';
import '../../../../../core/dp_injection/dependency_injection.dart';
import '../../../data/datasources/local_restaurant_detail_data_provider.dart';

class RestaurantPopularItemsBloc
    extends Bloc<RestaurantItemsEvent, RestaurantItemsState> {
  final GetPopularItemsUseCase getPopularItemsUseCase;

  RestaurantPopularItemsBloc({
    required this.getPopularItemsUseCase,
  }) : super(RestaurantPopularItemsFetching()) {
    on<GetRestaurantPopularItems>(_onGetPopularItems);
  }

  Future<void> _onGetPopularItems(
    GetRestaurantPopularItems event,
    Emitter<RestaurantItemsState> emit,
  ) async {
    try {
      emit(RestaurantPopularItemsFetching());

      // Access the local data source using dpLocator
      final localDataSource = dpLocator<RestaurantLocalDataSource>();

      // Fetch from network
      final response = await getPopularItemsUseCase(
        GetPopularItemsParams(
          restaurantId: event.restaurantId,
        ),
      );

      await response.fold(
        (error) async {
          // On network error, try fetching from cache again
          debugPrint('error in bloc left $error');
          final cachedFallbackItems =
              await localDataSource.getCachedPopularItems(event.restaurantId);

          if (cachedFallbackItems.isNotEmpty) {
            emit(RestaurantPopularItemsFetched(
                popularItems: cachedFallbackItems));
          } else {
            emit(
              RestaurantPopularItemsFetchingFailed(
                message: error.errorMessage,
              ),
            );
          }
        },
        (items) async {
          // Cache successful network response
          debugPrint('items in bloc right $items');
          await localDataSource.cachePopularItems(event.restaurantId, items);
          emit(RestaurantPopularItemsFetched(popularItems: items));
        },
      );
    } catch (e) {
      // Handle unexpected errors
      final localDataSource = dpLocator<RestaurantLocalDataSource>();
      final cachedFallbackItems =
          await localDataSource.getCachedPopularItems(event.restaurantId);

      if (cachedFallbackItems.isNotEmpty) {
        emit(RestaurantPopularItemsFetched(popularItems: cachedFallbackItems));
      } else {
        emit(
          RestaurantPopularItemsFetchingFailed(
            message: "An unexpected error occurred: $e",
          ),
        );
      }
    }
  }
}
