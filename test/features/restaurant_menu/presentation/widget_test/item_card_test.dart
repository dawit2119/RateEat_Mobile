import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/catagory_and_items/item_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  late ItemModel testItem;
  late String currencyCode;

  setUp(() {
    testItem = ItemModel(
      itemId: 'item123',
      itemName: 'Delicious Burger',
      price: 12.99,
      imageUrl: 'https://example.com/burger.jpg',
      averageRating: 4.5,
      numberOfReviews: 120,
      description: 'A tasty burger with all the fixings',
      ingredients: [],
    );

    currencyCode = 'USD';
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return Scaffold(
            body: CategoryItemCard(
              item: testItem,
              currencyCode: currencyCode,
            ),
          );
        },
      ),
    );
  }

  group('CategoryItemCard', () {
    testWidgets('renders correctly with all item details',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(testItem.itemName), findsOneWidget);

      expect(find.text('${testItem.price} $currencyCode'), findsOneWidget);

      expect(find.text('${testItem.averageRating}/5'), findsOneWidget);

      expect(find.byIcon(Icons.star_rounded), findsOneWidget);

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays loading shimmer when image is loading',
        (WidgetTester tester) async {
      testItem = testItem.copyWith(
        imageUrl: 'https://example.com/loading_forever.jpg',
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays error icon when image fails to load',
        (WidgetTester tester) async {
      testItem = testItem.copyWith(
        imageUrl: 'invalid_url',
      );

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('handles long item names with ellipsis',
        (WidgetTester tester) async {
      testItem = testItem.copyWith(
        itemName:
            'This is an extremely long item name that should definitely overflow and be truncated with an ellipsis',
      );

      await tester.pumpWidget(createWidgetUnderTest());

      final textWidget = tester.widget<Text>(find.text(testItem.itemName));

      expect(textWidget.maxLines, 1);

      expect(textWidget.overflow, TextOverflow.ellipsis);
    });
  });
}
