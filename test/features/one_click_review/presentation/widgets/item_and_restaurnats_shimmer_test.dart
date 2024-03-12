import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/item_and_restaurant_results_shimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  testWidgets('ItemAndRestaurantResultsShimmer builds correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResponsiveSizer(
            builder: (context, orientation, screenType) {
              return const ItemAndRestaurantResultsShimmer(shimmerCount: 3);
            },
          ),
        ),
      ),
    );

    expect(find.byType(Shimmer), findsWidgets);
    expect(find.byType(Container), findsWidgets);
  });
}
