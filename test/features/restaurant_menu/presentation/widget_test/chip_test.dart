import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/size_config.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/chip.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rateeat_mobile/src/core/theme/app_colors.dart';

void main() {
  testWidgets('Chips widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: Chips(
                isSelected: true,
                label: 'Test Chip',
              ),
            ),
          );
        },
      ),
    );

    // Verify that the widget is rendered.
    expect(find.text('Test Chip'), findsOneWidget);

    // Verify the background color when selected.
    final container = tester.firstWidget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, AppColors.primaryColor);

    //Verify the text color when selected.
    final textWidget = tester.firstWidget<Text>(find.byType(Text));
    expect(textWidget.style?.color, Colors.white);

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: Chips(
                isSelected: false,
                label: 'Test Chip',
              ),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    // Verify the background color when not selected.
    final container2 = tester.firstWidget<Container>(find.byType(Container));
    final decoration2 = container2.decoration as BoxDecoration;
    expect(decoration2.color, AppColors.grey100);

    //Verify the text color when not selected.
    final textWidget2 = tester.firstWidget<Text>(find.byType(Text));
    expect(textWidget2.style?.color, AppColors.grey500);
  });
}
