import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/item_result_header.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  testWidgets('ItemResultHeader renders correctly and triggers onTap',
      (WidgetTester tester) async {
    bool tapped = false;
    final mockCallback = () => tapped = true;
    const testPath = 'assets/icons/sample_icon.svg';

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: ItemResultHeader(
                path: testPath,
                onTap: mockCallback,
              ),
            ),
          );
        },
      ),
    );

    expect(find.byType(ItemResultHeader), findsOneWidget);
    expect(find.byType(InkWell), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
