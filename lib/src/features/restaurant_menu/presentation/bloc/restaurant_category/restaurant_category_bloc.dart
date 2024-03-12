import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/restaurant_category.dart';
import '../../../domain/use_cases/get_restaurant_menu_categories.dart';

part 'restaurant_category_event.dart';
part 'restaurant_category_state.dart';

class RestaurantCategoryBloc
    extends Bloc<RestaurantCategoryEvent, RestaurantCategoryState> {
  final GetRestaurantMenuCategories getRestaurantMenuCategories;
  RestaurantCategoryBloc({
    required this.getRestaurantMenuCategories,
  }) : super(RestaurantCategoriesLoading()) {
    on<GetRestaurantCategoriesEvent>(_onGetCategoriesEvent);
  }
  void _onGetCategoriesEvent(
      GetRestaurantCategoriesEvent event, Emitter emit) async {
    try {
      var response = await getRestaurantMenuCategories(
        event.restaurantId,
      );
      response.fold(
        (l) => emit(
          const RestaurantCategoriesLoadingFailed(
            message: "Unable to load categories",
          ),
        ),
        (categories) => emit(
          RestaurantCategoriesLoaded(
            categories: categories,
          ),
        ),
      );
    } catch (e) {
      emit(
        const RestaurantCategoriesLoadingFailed(
          message: "Unable to load categories",
        ),
      );
    }
  }
}
