import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/size_config.dart';
import 'package:rateeat_mobile/src/features/homepage/data/models/item_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/catagory_and_items/category_items.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/category.dart';

void main() {
  testWidgets('RestaurantCategoryItem widget test',
      (WidgetTester tester) async {
    final category = CategoryEntity(
      name: 'Desserts',
      items: [
        ItemModel(itemName: 'Cake', itemId: '1', numberOfReviews: 0),
        ItemModel(itemName: 'Ice Cream', itemId: '1', numberOfReviews: 0),
      ],
    );

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: RestaurantCategoryItem(category: category),
            ),
          );
        },
      ),
    );

    // Verify the category name is displayed.
    expect(find.text('Desserts'), findsOneWidget);

    // Verify the item cards are displayed.
    expect(find.text('Cake - '), findsOneWidget);
    expect(find.text('Ice Cream - '), findsOneWidget);

    // Verify the text style of the category name.
    final textWidget = tester.firstWidget<Text>(find.text('Desserts'));
    expect(textWidget.style?.fontSize, 2.h);
    expect(textWidget.style?.fontWeight, FontWeight.w500);

    // Test with empty item list
    final emptyCategory = CategoryEntity(name: 'Drinks', items: []);

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: RestaurantCategoryItem(category: emptyCategory),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Drinks'), findsOneWidget);
    expect(find.text('Cake - '), findsNothing);
    expect(find.text('Ice Cream - '), findsNothing);

    //Test with null category name.
    final nullCategory = CategoryEntity(
        name: null,
        items: [ItemModel(itemName: "Soda", itemId: '1', numberOfReviews: 0)]);

    await tester.pumpWidget(
        ResponsiveSizer(builder: (context, orientation, screenType) {
      SizeConfig().init(context);
      return MaterialApp(
        home: Scaffold(
          body: RestaurantCategoryItem(category: nullCategory),
        ),
      );
    }));
    await tester.pumpAndSettle();

    expect(find.text("Soda - "), findsOneWidget);
    expect(find.text(""), findsOneWidget);
  });
}
