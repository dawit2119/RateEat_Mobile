import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/filer_page_usecase.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/filter/filter_items_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/filter/filter_items_state.dart';
import 'package:rateeat_mobile/src/features/homepage/data/data.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

class FilterItemsBloc extends Bloc<FilterItemsEvent, FilterItemsState> {
  final FilterItemsUseCase filterItemsUseCase;

  FilterItemsBloc({required this.filterItemsUseCase})
      : super(FilterItemsInitial()) {
    on<GetFilteredItemsEvent>((event, emit) async {
      final filteredItems = (state is FilterItemsLoaded)
          ? (state as FilterItemsLoaded).items
          : [];

      if (event.page == 1) {
        emit(FilterItemsLoading());
      } else {
        emit(FilterItemsLoadingMore(items: filteredItems as List<Item>));
      }

      try {
        var response = await filterItemsUseCase.getRestaurantItems(
          event.restaurantId,
          event.maxPrice,
          event.fasting,
          event.sortingQuery,
          event.searchQuery,
          event.categoryId ?? "",
          event.page,
          event.limit,
        );

        response.fold(
            (l) => emit(
                  //Todo display customized message based on the error you get
                  FilterItemsError(error: "Failed"),
                ), (items) {
          if (event.page == 1) {
            emit(FilterItemsLoaded(items: items, isLoadingMore: true));
          } else {
            emit(
              FilterItemsLoaded(
                items: List.of(filteredItems as List<Item>)..addAll(items),
                isLoadingMore: true,
                hasReachedMax: items.isEmpty,
              ),
            );
          }
        });
      } catch (e) {
        if (event.page == 1) {
          emit(FilterItemsError(error: e.toString()));
        } else {
          emit(
            FilterItemsLoaded(
              items: filteredItems as List<ItemModel>,
              isLoadingMore: false,
            ),
          );
        }
      }
    });
    on<ResetFilterItemsEvent>(
      (event, emit) => emit(FilterItemsInitial()),
    );
  }
}
