import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/size_config.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/error_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('RestaurantMenuErrorWidget test', (WidgetTester tester) async {
    bool refreshButtonPressed = false;
    final refreshButtonOnPressed = () {
      refreshButtonPressed = true;
    };

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          SizeConfig().init(context);
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            home: Scaffold(
              body: RestaurantMenuErrorWidget(
                message: 'Test Error Message',
                restaurantId: '123',
                refreshButtonOnPressed: refreshButtonOnPressed,
              ),
            ),
          );
        },
      ),
    );

    expect(find.text('Test Error Message'), findsOneWidget);

    expect(find.text('Refresh'), findsOneWidget);

    await tester.tap(find.text('Refresh'));
    await tester.pump();
    expect(refreshButtonPressed, true);

    final textButton = tester.firstWidget<TextButton>(find.byType(TextButton));
    final text = tester.firstWidget<Text>(find.descendant(
        of: find.byWidget(textButton), matching: find.byType(Text)));
    expect(text.style?.color, Colors.red);
  });
}
