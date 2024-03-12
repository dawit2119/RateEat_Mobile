import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/search_page_use_case.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/search_restaurant_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/search_restaurant_state.dart';

class SearchRestaurantsBloc
    extends Bloc<SearchRestaurantEvent, SearchRestaurantState> {
  final SearchPageUseCase searchPageUseCase;
  SearchRestaurantsBloc({required this.searchPageUseCase})
      : super(SearchRestaurantInitial()) {
    on<RestaurantSearchSubmitted>(
      (event, emit) async {
        emit(SearchRestaurantLoading());
        try {
          final result = await searchPageUseCase.searchRestaurants(event.query);
          result.fold((error) {
            emit(
              SearchRestaurantsError(message: error.errorMessage),
            );
          },
              (results) => emit(
                    SearchRestaurantSuccess(results),
                  ));
        } catch (e) {
          emit(SearchRestaurantsError(message: e.toString()));
        }
      },
    );
  }
}
