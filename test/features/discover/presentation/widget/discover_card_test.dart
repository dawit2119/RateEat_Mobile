import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/widgets/discover_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  // Test data
  const testTitle = 'Choose restaurant';
  const testSubtitle =
      'Find restaurants based on distance, cuisine, and quality';
  const testSvgUrl = 'assets/images/connection_lost.svg';

  // Helper method to create testable widget
  Widget createDiscoverCard({
    String? title,
    String? subtitle,
    String? svgUrl,
    GestureTapCallback? onTap,
  }) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      SizeConfig().init(context);
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: DiscoverCard(
            title: title ?? testTitle,
            subtitle: subtitle ?? testSubtitle,
            svgUrl: svgUrl ?? testSvgUrl,
            onTap: onTap ?? () {},
          ),
        ),
      );
    });
  }

  group('DiscoverCard Widget', () {
    testWidgets('renders correctly with given parameters',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDiscoverCard());

      // Verify title
      final titleFinder = find.text(testTitle);
      expect(titleFinder, findsOneWidget);

      // Verify subtitle
      final subtitleFinder = find.text(testSubtitle);
      expect(subtitleFinder, findsOneWidget);

      // Verify SVG image
      final svgFinder = find.byType(SvgPicture);
      expect(svgFinder, findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(createDiscoverCard(
        onTap: () {
          wasTapped = true;
        },
      ));

      // Find the InkWell widget
      final inkWellFinder = find.byType(InkWell);

      // Tap the card
      await tester.tap(inkWellFinder);
      await tester.pumpAndSettle();

      // Verify onTap was called
      expect(wasTapped, isTrue);
    });

    testWidgets('renders with custom title and subtitle',
        (WidgetTester tester) async {
      const customTitle = 'Custom Title';
      const customSubtitle = 'Custom Subtitle';

      await tester.pumpWidget(createDiscoverCard(
        title: customTitle,
        subtitle: customSubtitle,
      ));

      // Verify custom title
      final titleFinder = find.text(customTitle);
      expect(titleFinder, findsOneWidget);

      // Verify custom subtitle
      final subtitleFinder = find.text(customSubtitle);
      expect(subtitleFinder, findsOneWidget);
    });

    // testWidgets('renders with different SVG', (WidgetTester tester) async {
    //   const customSvgUrl = 'assets/images/custom_image.svg';

    //   await tester.pumpWidget(createDiscoverCard(
    //     svgUrl: customSvgUrl,
    //   ));

    //   // Find SvgPicture with custom URL
    //   final svgFinder = find.byWidgetPredicate((widget) =>
    //       widget is SvgPicture &&
    //       (widget.pictureProvider as AssetPicture).assetName == customSvgUrl);

    //   expect(svgFinder, findsOneWidget);
    // });

    testWidgets('has correct layout and styling', (WidgetTester tester) async {
      await tester.pumpWidget(createDiscoverCard());

      // Find the Ink widget
      final inkFinder = find.byType(Ink);
      expect(inkFinder, findsOneWidget);

      // Get the Ink widget
      final inkWidget = tester.widget<Ink>(inkFinder);

      // Verify decoration
      expect(inkWidget.decoration, isNotNull);

      // Verify row structure
      final rowFinder = find.byType(Row);
      expect(rowFinder, findsOneWidget);
    });

    testWidgets('accessibility test', (WidgetTester tester) async {
      await tester.pumpWidget(createDiscoverCard());

      // Check for semantics
      final semanticsFinder = find.byType(InkWell);
      expect(semanticsFinder, findsOneWidget);
    });
  });
}
