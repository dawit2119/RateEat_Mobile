import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/size_config.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/food_card.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/dishes.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/search_result_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  testWidgets('RestaurantDishesList displays food items correctly',
      (WidgetTester tester) async {
    final List<Item> testItems = [
      Item(
        id: '1',
        name: 'Classic Burger',
        description: 'A delicious beef burger with cheese and lettuce.',
        numberOfReviews: 150,
        averageRating: 4,
        price: 12.99,
        categoryId: 'fast_food',
        fasting: false,
        popularityIndex: 95,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 3, 1),
        itemTags: [],
      ),
      Item(
        id: '2',
        name: 'Margherita Pizza',
        description: 'Classic Italian pizza with fresh tomatoes and basil.',
        numberOfReviews: 200,
        averageRating: 5,
        price: 15.99,
        categoryId: 'italian',
        fasting: true,
        popularityIndex: 90,
        createdAt: DateTime(2023, 12, 10),
        updatedAt: DateTime(2024, 2, 15),
        itemTags: [],
      ),
    ];

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ResponsiveSizer(
          builder: (context, orientation, screenType) {
            SizeConfig().init(context);
            return Scaffold(
              body: RestaurantDishesList(items: testItems),
            );
          },
        ),
      ),
    );

    expect(find.byType(FoodCard), findsNWidgets(testItems.length + 1));

    expect(find.text('Classic Burger'), findsOneWidget);
    expect(find.text('Margherita Pizza'), findsOneWidget);

    expect(find.text('Special Shawarma combo'), findsOneWidget);
  });
}
