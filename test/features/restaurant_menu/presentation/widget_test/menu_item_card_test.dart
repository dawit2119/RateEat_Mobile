// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:rateeat_mobile/src/core/constants/size_config.dart';
// import 'package:rateeat_mobile/src/features/live_search/data/models/search_result_model.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
// import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/menu_item_card.dart';
// import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

// void main() {
//   testWidgets('MenuFoodCard renders correctly', (WidgetTester tester) async {
//     final item = Item(
//       itemId: '1',
//       itemName: 'Test Item',
//       imageUrl: 'https://example.com/image.jpg',
//       averageRating: 4.5,
//       price: 10.0,
//       numberOfReviews: 10,
//     );

//     await tester.pumpWidget(
//       ResponsiveSizer(
//         builder: (context, orientation, screenType) {
//           return MaterialApp(
//             localizationsDelegates: const [
//               AppLocalizations.delegate,
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate,
//             ],
//             supportedLocales: AppLocalizations.supportedLocales,
//             home: Scaffold(
//               body: MenuFoodCard(item: item),
//             ),
//           );
//         },
//       ),
//     );

//     // Initialize SizeConfig
//     SizeConfig().init(tester.element(find.byType(MenuFoodCard)));

//     // Wait for any animations to complete
//     for (var i = 0; i < 10; i++) {
//       await tester.pump(Duration(milliseconds: 100));
//     }
//     await tester.pumpAndSettle();

//     // Verify that the MenuFoodCard is rendered
//     expect(find.byType(MenuFoodCard), findsOneWidget);

//     // Verify that the item name is displayed
//     expect(find.text('Test Item'), findsOneWidget);

//     // Verify that the price is displayed
//     expect(find.text('10.0 ETB'), findsOneWidget);

//     // Verify that the rating is displayed
//     expect(find.text('4.5'), findsOneWidget);
//   });
// }
