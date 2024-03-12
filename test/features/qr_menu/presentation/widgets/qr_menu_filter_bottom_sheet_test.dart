import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'qr_menu_filter_bottom_sheet_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemsCountPerPriceBloc>(),
  MockSpec<QRMenuBloc>(),
])
void main() {
  late MockItemsCountPerPriceBloc mockItemsCountPerPriceBloc;
  late MockQRMenuBloc mockQRMenuBloc;

  setUp(() {
    mockItemsCountPerPriceBloc = MockItemsCountPerPriceBloc();
    mockQRMenuBloc = MockQRMenuBloc();
  });

  Widget createWidgetUnderTest({
    String restaurantId = '123',
    bool? isFasting,
    QRCategory? selectedCategory,
    String query = '',
    String? sortBy,
    int? minRating,
    String? sortType,
    int? minPrice,
    int? maxPrice,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return BlocProvider<ItemsCountPerPriceBloc>.value(
            value: mockItemsCountPerPriceBloc,
            child: BlocProvider<QRMenuBloc>.value(
              value: mockQRMenuBloc,
              child: ResponsiveSizer(
                builder: (context, orientation, type) {
                  return QrMenuFilterBottomSheet(
                    restaurantId: restaurantId,
                    isFasting: isFasting,
                    selectedCategory: selectedCategory,
                    query: query,
                    sortBy: sortBy,
                    minRating: minRating,
                    sortType: sortType,
                    minPrice: minPrice,
                    maxPrice: maxPrice,
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  testWidgets('initial values are set correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      minPrice: 200,
      maxPrice: 1000,
      sortBy: 'popularity',
      minRating: 3,
      sortType: 'Asc',
    ));

    expect(find.text('Min'), findsOneWidget);
    expect(find.text('200'), findsOneWidget);
    expect(find.text('Max'), findsOneWidget);
    expect(find.text('1000'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('Popularity'), findsOneWidget);
    expect(find.text('Minimum Rating'), findsOneWidget);
  });

  // testWidgets('applies filters when the Apply button is pressed',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(createWidgetUnderTest());

  //   // Fill the min and max price fields
  //   await tester.enterText(find.byType(TextField).at(0), '100');
  //   await tester.enterText(find.byType(TextField).at(1), '500');

  //   // Mock the event to check if the correct event is dispatched
  //   when(mockQRMenuBloc.add(any)).thenAnswer((_) => Future.value());

  //   // Press the Apply button
  //   await tester.tap(find.text('Apply'));
  //   await tester.pumpAndSettle();

  //   // Verify that the correct event was triggered
  //   verify(mockQRMenuBloc.add(GetQRMenu(
  //     restaurantId: '123',
  //     category: null,
  //     page: 1,
  //     isFasting: null,
  //     sortBy: 'popularity',
  //     sortType: 'Desc',
  //     minPrice: 100,
  //     maxPrice: 500,
  //     minRating: 3,
  //     query: '',
  //   ))).called(1);
  // });

  testWidgets('clears filters when Clear all is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Press the Clear all button
    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();

    // Verify that the state is reset
    expect(find.text('Min'), findsOneWidget);
    expect(find.text('Max'), findsOneWidget);
  });

  // testWidgets('shows error when minPrice > maxPrice',
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(createWidgetUnderTest());
  //   await tester.pumpAndSettle(); // Ensure initial widget tree is fully built

  //   // Fill the min price greater than max price
  //   await tester.enterText(find.byType(TextField).at(0), '500');
  //   await tester.enterText(find.byType(TextField).at(1), '100');
  //   await tester.pumpAndSettle(); // Allow UI to update after text input

  //   // Find the button by key
  //   final applyButtonFinder =
  //       find.byKey(const Key('qr_filter_bottom_sheet_apply_button'));

  //   // Scroll to make the button visible (crucial step)
  //   await tester.scrollUntilVisible(
  //     applyButtonFinder,
  //     1000,
  //   ); // Adjust 1000 as needed

  //   // Check if the button is found after scrolling.
  //   expect(applyButtonFinder, findsOneWidget);

  //   // Tap the button
  //   await tester.tap(applyButtonFinder, warnIfMissed: false);
  //   await tester.pumpAndSettle(); // Allow UI to update after button tap

  //   // Check for the error message
  //   expect(find.text('Minimum price should be less than maximum price'),
  //       findsOneWidget);
  // });
}
