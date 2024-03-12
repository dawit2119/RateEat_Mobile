import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/menu.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/get_restaurant_menu_category_items_use_case.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/get_restaurant_menu_items_use_case.dart';

import '../../../domain/entities/menu.dart';

part 'restaurant_menu_event.dart';
part 'restaurant_menu_state.dart';

class RestaurantMenuBloc
    extends Bloc<RestaurantMenuEvent, RestaurantMenuState> {
  final GetRestaurantMenuItemsUseCase itemsUseCase;
  final GetRestaurantMenuCategoryItemsUseCase categoryItemsUseCase;
  RestaurantMenuBloc({
    required this.itemsUseCase,
    required this.categoryItemsUseCase,
  }) : super(
          RestaurantMenuCategoryItemsFetching(),
        ) {
    on<GetRestaurantMenuCategoryItems>(
      _getEitherRestaurantMenuCategoryItemsOrError,
    );
  }
  void _getEitherRestaurantMenuCategoryItemsOrError(
      GetRestaurantMenuCategoryItems event,
      Emitter<RestaurantMenuState> emit) async {
    try {
      dynamic previouslyFetchedItems =
          (state is RestaurantMenuCategoryItemsFetched) ? state : null;
      if (event.page == 1) {
        emit(
          RestaurantMenuCategoryItemsFetching(),
        );
      } else {
        emit(
          RestaurantMenuCategoryItemsNextLoading(
            menu: previouslyFetchedItems.menu,
            categoryId: previouslyFetchedItems.categoryId,
          ),
        );
      }
      final response = await categoryItemsUseCase(
        GetRestaurantMenuCategoryItemsParams(
            restaurantId: event.restaurantId,
            categoryId: event.categoryId,
            page: event.page,
            limit: event.limit,
            query: event.query,
            sortBy: event.sortBy),
      );
      return response.fold((error) {
        if (event.page == 1) {
          emit(
            const RestaurantMenuCategoryItemsFetchingFailed(
              message: "Failed to fetch items",
            ),
          );
        } else {
          emit(
            RestaurantMenuCategoryItemsFetched(
              menu: previouslyFetchedItems.menu,
              categoryId: event.categoryId,
              isFetchingSuccessful: false,
              page: event.page - 1,
              query: event.query,
            ),
          );
        }
      }, (menu) {
        if (event.page == 1) {
          emit(
            RestaurantMenuCategoryItemsFetched(
                menu: menu,
                categoryId: event.categoryId,
                hasMaxReached: menu.loadedItemsCount == menu.totalItemsCount,
                page: event.page,
                query: event.query),
          );
        } else {
          emit(
            RestaurantMenuCategoryItemsFetched(
              menu: MenuModel(
                  id: menu.id,
                  items: previouslyFetchedItems.menu.items
                    ..addAll(
                      menu.items,
                    ),
                  totalItemsCount: previouslyFetchedItems.menu.totalItemsCount,
                  loadedItemsCount: menu.loadedItemsCount),
              categoryId: previouslyFetchedItems.categoryId,
              page: event.page,
              query: event.query,
              hasMaxReached: previouslyFetchedItems.menu.totalItemsCount ==
                  menu.loadedItemsCount,
            ),
          );
        }
      });
    } catch (e) {
      emit(
        const RestaurantMenuCategoryItemsFetchingFailed(
          message: "Something went wrong",
        ),
      );
    }
  }
}
