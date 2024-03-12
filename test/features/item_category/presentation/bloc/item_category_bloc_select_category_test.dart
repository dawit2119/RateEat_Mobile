import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/bloc/item_category_bloc.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/bloc/item_category_event.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/bloc/item_category_state.dart';

void main() {
  group('SelectFoodCategoryBloc', () {
    late SelectFoodCategoryBloc selectFoodCategoryBloc;

    setUp(() {
      selectFoodCategoryBloc = SelectFoodCategoryBloc();
    });

    tearDown(() {
      selectFoodCategoryBloc.close();
    });

    blocTest<SelectFoodCategoryBloc, SelectedFoodCategoryState>(
      'emits new selected category when SelectFoodCategory is added',
      build: () => selectFoodCategoryBloc,
      act: (bloc) => bloc.add(SelectFoodCategory(foodCategory: 'Fruits')),
      expect: () => [
        const SelectedFoodCategoryState([
          'Fruits',
        ]),
      ],
    );

    blocTest<SelectFoodCategoryBloc, SelectedFoodCategoryState>(
      'emits new state with category removed when UnselectFoodCategory is added',
      build: () {
        selectFoodCategoryBloc.add(SelectFoodCategory(foodCategory: 'Fruits'));
        return selectFoodCategoryBloc;
      },
      act: (bloc) => bloc.add(UnselectFoodCategory(foodCategory: 'Fruits')),
      expect: () => [
        const SelectedFoodCategoryState([
          'Fruits',
        ]),
        const SelectedFoodCategoryState([]),
      ],
    );

    blocTest<SelectFoodCategoryBloc, SelectedFoodCategoryState>(
      'emits empty state when ResetCategoryEvent is added',
      build: () {
        selectFoodCategoryBloc.add(SelectFoodCategory(foodCategory: 'Fruits'));
        return selectFoodCategoryBloc;
      },
      act: (bloc) => bloc.add(ResetCategoryEvent()),
      expect: () => [
        const SelectedFoodCategoryState([
          'Fruits',
        ]),
        const SelectedFoodCategoryState([]),
      ],
    );

    blocTest<SelectFoodCategoryBloc, SelectedFoodCategoryState>(
      'emits state with new category when CreateNewCategory is added',
      build: () => selectFoodCategoryBloc,
      act: (bloc) => bloc.add(CreateNewCategory(foodCategory: 'Vegetables')),
      expect: () => [
        const SelectedFoodCategoryState([
          'Vegetables',
        ]),
      ],
    );

    blocTest<SelectFoodCategoryBloc, SelectedFoodCategoryState>(
      'emits combined state when multiple categories are selected',
      build: () {
        selectFoodCategoryBloc.add(SelectFoodCategory(foodCategory: 'Fruits'));
        return selectFoodCategoryBloc;
      },
      act: (bloc) {
        bloc.add(SelectFoodCategory(foodCategory: 'Vegetables'));
      },
      expect: () => [
        const SelectedFoodCategoryState([
          'Fruits',
        ]),
        const SelectedFoodCategoryState([
          'Fruits',
          'Vegetables',
        ]),
      ],
    );
  });
}
