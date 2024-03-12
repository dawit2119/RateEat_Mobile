import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/result_header.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dotted_border/dotted_border.dart';

void main() {
  testWidgets('ResultHeader renders correctly and triggers callbacks',
      (WidgetTester tester) async {
    bool searchTapped = false;
    bool filterTapped = false;
    final searchCallback = () => searchTapped = true;
    final filterCallback = () => filterTapped = true;
    const testName = 'Test Location';

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            home: Scaffold(
              body: ResultHeader(
                name: testName,
                searchTap: searchCallback,
                filterTap: filterCallback,
              ),
            ),
          );
        },
      ),
    );

    expect(find.byType(ResultHeader), findsOneWidget);
    expect(find.byType(DottedBorder), findsOneWidget);
    expect(find.byType(InkWell), findsNWidgets(2));
    expect(find.byType(SvgPicture), findsNWidgets(2));
    expect(find.text(testName), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    expect(filterTapped, isTrue);

    await tester.tap(find.byType(InkWell).last);
    await tester.pump();
    expect(searchTapped, isTrue);
  });
}
