import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/widgets/selected_item_category_tile.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/widgets/tag_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'item_category_screen_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SearchFoodCategoryBloc>(),
  MockSpec<SelectFoodCategoryBloc>(),
])
void main() {
  late MockSearchFoodCategoryBloc mockSearchBloc;
  late MockSelectFoodCategoryBloc mockSelectBloc;

  setUp(() {
    mockSearchBloc = MockSearchFoodCategoryBloc();
    mockSelectBloc = MockSelectFoodCategoryBloc();

    when(mockSearchBloc.state).thenReturn(SearchSuccess([]));
    when(mockSelectBloc.state).thenReturn(SelectedFoodCategoryState([]));
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchFoodCategoryBloc>(
          create: (context) => mockSearchBloc,
        ),
        BlocProvider<SelectFoodCategoryBloc>(
          create: (context) => mockSelectBloc,
        ),
      ],
      child: ResponsiveSizer(builder: (context, orientation, screenType) {
        SizeConfig().init(context);
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SelectFoodCategoryScreen(),
        );
      }),
    );
  }

  group("item category screen tests", () {
    testWidgets('renders initial state correctly', (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(SearchInitial());
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Start Searching...'), findsOneWidget);
    });

    testWidgets('displays loading indicator when fetching categories',
        (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(SearchLoading());
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TagShimmer), findsNWidgets(15));
    });

    testWidgets('displays error message on search error',
        (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(SearchError(message: 'Error'));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No results found'), findsOneWidget);
      expect(find.byType(ErrorAndInfoDisplayWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('displays items when search is successful',
        (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(
        SearchSuccess([ItemCategoryModel(id: '1', name: 'Fruits')]),
      );
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Fruits'), findsOneWidget);
      expect(find.byType(ItemCategoryTile), findsOne);
    });

    testWidgets('selects a category', (WidgetTester tester) async {
      when(mockSelectBloc.state).thenReturn(SelectedFoodCategoryState([]));
      when(mockSearchBloc.state).thenReturn(
          SearchSuccess([ItemCategoryModel(id: '1', name: 'Fruits')]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ItemCategoryTile));
      verify(mockSelectBloc.add(SelectFoodCategory(foodCategory: 'Fruits')))
          .called(1);
    });

    testWidgets(
        'unselects a category from item tile if item is already selected',
        (WidgetTester tester) async {
      when(mockSelectBloc.state)
          .thenReturn(SelectedFoodCategoryState(['Fruits']));
      when(mockSearchBloc.state).thenReturn(
          SearchSuccess([ItemCategoryModel(id: '1', name: 'Fruits')]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ItemCategoryTile));
      verify(mockSelectBloc.add(UnselectFoodCategory(foodCategory: 'Fruits')))
          .called(1);
    });

    testWidgets('unselects a category from selected categories tiles',
        (WidgetTester tester) async {
      when(mockSelectBloc.state)
          .thenReturn(SelectedFoodCategoryState(['Fruits']));
      when(mockSearchBloc.state).thenReturn(
          SearchSuccess([ItemCategoryModel(id: '1', name: 'Fruits')]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SelectedItemCategoryTile));
      verify(mockSelectBloc.add(UnselectFoodCategory(foodCategory: 'Fruits')))
          .called(1);
    });

    testWidgets('searches when typing in the search field',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final searchField = find.byType(CustomTextInputField);
      await tester.enterText(searchField, 'Fruits');
      await tester.pumpAndSettle();

      verify(mockSearchBloc
              .add(SearchSubmitted(query: 'Fruits', pageNumber: 1)))
          .called(1);
    });
  });
}
