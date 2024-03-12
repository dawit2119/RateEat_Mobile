import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/selected_restaurant_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/selected_restaurant_state.dart';

class SelectedRestaurantBloc
    extends Bloc<RestaurantSelectedEvent, SelectedRestaurantState> {
  SelectedRestaurantBloc() : super(SelectedRestaurantInitial()) {
    on<RestaurantSelected>((event, emit) {
      emit(RestaurantSelectedSuccess(event.selectedRestaurant));
    });
  }
}
