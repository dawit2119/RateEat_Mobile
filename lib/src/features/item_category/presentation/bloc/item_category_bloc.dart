import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/item_category/domain/entity/item_category.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/bloc/item_category_event.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/bloc/item_category_state.dart';

import '../../data/dataprovider/local_item_category_data_provider.dart';
import '../../data/models/item_category_model.dart';
import '../../domain/use_case/use_case.dart';

class SearchFoodCategoryBloc
    extends Bloc<SearchFoodCategoryEvent, SearchFoodCategoryState> {
  final GeTagSuggestionUseCase geTagSuggestionUseCase;
  final SearchFoodCategoryUseCase searchFoodCategoryUseCase;
  SearchFoodCategoryBloc(
      {required this.geTagSuggestionUseCase,
      required this.searchFoodCategoryUseCase})
      : super(SearchLoading()) {
    on<SearchSubmitted>(_searchSubmitted);
    on<GetCategorySuggestion>(_getCategorySuggestion);
  }

  Future<void> _getCategorySuggestion(
      GetCategorySuggestion event, Emitter emit) async {
    emit(SearchLoading());
    try {
      final response = await geTagSuggestionUseCase(
        NoParams(),
      );
      List<ItemCategory> localCategories =
          await dpLocator<LocalItemCategoryDataProvider>().getItemCategories();
      response.fold((error) {
        if (localCategories.isNotEmpty) {
          emit(SearchSuccess(
            localCategories
                .map((category) => ItemCategoryModel.fromEntity(category))
                .toList(),
          ));
        } else {
          emit(
            SearchError(message: error.errorMessage),
          );
        }
      }, (itemCategories) {
        emit(
          SearchSuccess(itemCategories),
        );
        dpLocator<LocalItemCategoryDataProvider>().clearItemCategories();
        dpLocator<LocalItemCategoryDataProvider>()
            .cacheItemCategories(itemCategories);
      });
    } catch (e) {
      emit(
        SearchError(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _searchSubmitted(SearchSubmitted event, Emitter emit) async {
    emit(SearchLoading());
    try {
      final response = await searchFoodCategoryUseCase(
        SearchFoodCategoryUseCaseParams(
            query: event.query, pageNumber: event.pageNumber),
      );
      response.fold(
        (error) {
          emit(
            SearchError(message: error.errorMessage),
          );
        },
        (itemCategories) => emit(
          SearchSuccess(itemCategories),
        ),
      );
    } catch (e) {
      emit(
        SearchError(
          message: e.toString(),
        ),
      );
    }
  }
}

class SelectFoodCategoryBloc
    extends Bloc<SelectFoodCategoryEvent, SelectedFoodCategoryState> {
  SelectFoodCategoryBloc() : super(const SelectedFoodCategoryState([])) {
    on<SelectFoodCategory>(_selectFoodCategory);
    on<UnselectFoodCategory>(_unselectedFoodCategories);
    on<CreateNewCategory>(_createNewCategory);
    on<ResetCategoryEvent>(_onResetCategory);
  }

  Future<void> _selectFoodCategory(
      SelectFoodCategory event, Emitter<SelectedFoodCategoryState> emit) async {
    var newCategoryList = [...state.selectedCategories];
    newCategoryList.add(event.foodCategory);
    emit(SelectedFoodCategoryState(newCategoryList));
  }

  Future<void> _unselectedFoodCategories(UnselectFoodCategory event,
      Emitter<SelectedFoodCategoryState> emit) async {
    var newCategoryList = [...state.selectedCategories];
    newCategoryList.remove(event.foodCategory);
    emit(SelectedFoodCategoryState(newCategoryList));
  }

  Future<void> _onResetCategory(
      ResetCategoryEvent event, Emitter<SelectedFoodCategoryState> emit) async {
    emit(const SelectedFoodCategoryState([]));
  }

  Future<void> _createNewCategory(
      CreateNewCategory event, Emitter<SelectedFoodCategoryState> emit) async {
    var newCategoryList = [event.foodCategory];
    emit(SelectedFoodCategoryState(newCategoryList));
  }
}
