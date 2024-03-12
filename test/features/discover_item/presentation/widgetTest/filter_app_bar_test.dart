import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/filter_app_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  testWidgets('FilterAppBar renders correctly', (WidgetTester tester) async {
    bool tapped = false;
    final mockCallback = () => tapped = true;

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              appBar: FilterAppBar(onTap: mockCallback),
            ),
          );
        },
      ),
    );

    expect(find.byType(FilterAppBar), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Filter items'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
  });
}
