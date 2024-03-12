import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/restaurant_name_dotted_border.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  testWidgets('RestaurantNameDottedBorder renders correctly with given title',
      (WidgetTester tester) async {
    const String testTitle = 'Test Restaurant Name';

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: RestaurantNameDottedBorder(title: testTitle),
            ),
          );
        },
      ),
    );

    expect(find.text(testTitle), findsOneWidget);

    final textWidget = tester.widget<Text>(find.text(testTitle));
    expect(textWidget.maxLines, equals(2));
    expect(textWidget.style?.fontSize, equals(2.h));
    expect(textWidget.style?.fontWeight, equals(FontWeight.w500));
    expect(textWidget.style?.color, equals(AppColors.secondaryColor));
  });
}
