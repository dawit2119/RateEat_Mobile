import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/category/category_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/category/category_state.dart';
import '../../../domain/use_cases/categories_usecase.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoriesUsecase categoriesUsecase;

  CategoryBloc({required this.categoriesUsecase}) : super(CategoryInitial()) {
    on<GetCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());
      try {
        var response =
            await categoriesUsecase.getCategories(event.restaurantId);
        log(response.toString(), name: 'CategoryBloc');
        response.fold(
          (l) => emit(
            const CategoryError(error: 'Failed'),
          ),
          (categories) {
            emit(CategoryLoaded(categories: categories));
          },
        );
      } catch (e) {
        emit(CategoryError(error: e.toString()));
      }
    });
  }
}
