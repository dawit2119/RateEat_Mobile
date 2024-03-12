import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/restaurant_dotted_border.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dotted_border/dotted_border.dart';

void main() {
  testWidgets('RestaurantDottedBorder renders correctly',
      (WidgetTester tester) async {
    const testTitle = 'Test Restaurant';

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: RestaurantDottedBorder(title: testTitle),
            ),
          );
        },
      ),
    );

    expect(find.byType(RestaurantDottedBorder), findsOneWidget);
    expect(find.byType(DottedBorder), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text(testTitle), findsOneWidget);

    final textWidget = tester.widget<Text>(find.text(testTitle));
    expect(textWidget.style?.fontSize, equals(16.sp));
    expect(textWidget.style?.fontWeight, equals(FontWeight.w600));
    expect(textWidget.style?.color, equals(AppColors.secondaryColor));
  });
}
