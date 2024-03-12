import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/item_price_chips.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  testWidgets('ItemPriceChips renders correctly and displays chips',
      (WidgetTester tester) async {
    const testPrices = [10, 20, 30, 40, 50, 60];
    const testCurrencyCode = 'USD';

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return const MaterialApp(
            home: Scaffold(
              body: ItemPriceChips(
                prices: testPrices,
                currencyCode: testCurrencyCode,
              ),
            ),
          );
        },
      ),
    );

    expect(find.byType(ItemPriceChips), findsOneWidget);
    expect(find.byType(SingleItemChip), findsNWidgets(6));

    for (int i = 0; i < testPrices.length; i++) {
      expect(find.text('${testPrices[i]} $testCurrencyCode'), findsOneWidget);
    }
  });

  testWidgets('SingleItemChip renders correctly and triggers onTap',
      (WidgetTester tester) async {
    bool tapped = false;
    final mockCallback = () => tapped = true;
    const testTitle = '10 USD';

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: SingleItemChip(
                selected: false,
                title: testTitle,
                onTap: mockCallback,
              ),
            ),
          );
        },
      ),
    );

    expect(find.byType(SingleItemChip), findsOneWidget);
    expect(find.text(testTitle), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
