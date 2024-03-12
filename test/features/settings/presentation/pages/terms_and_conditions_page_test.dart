import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/terms_and_conditions_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'terms_and_conditions_page_test.mocks.dart';

String extractTextFromTextSpan(TextSpan textSpan) {
  final buffer = StringBuffer();
  void extractSpan(TextSpan span) {
    if (span.text != null) buffer.write(span.text);
    if (span.children != null) {
      for (var child in span.children!) {
        if (child is TextSpan) extractSpan(child);
      }
    }
  }

  extractSpan(textSpan);
  return buffer.toString();
}

@GenerateNiceMocks([
  MockSpec<GoRouter>(),
])
void main() {
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();
  });

  Widget createTestWidget() {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        SizeConfig().init(context);
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TermsAndConditionsPage(),
        );
      },
    );
  }

  testWidgets('renders Terms and Conditions page correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    final scaffoldElement = tester.element(find.byType(Scaffold));
    debugPrint(scaffoldElement.toStringDeep());

    expect(find.byKey(Key('terms_and_conditions_rich_text')), findsOneWidget);
  });

  testWidgets('TermsAndConditionsPage contains expected text',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final richTextWidget = tester.widget<RichText>(find.byType(RichText).first);

    final textSpan = richTextWidget.text as TextSpan;
    final textContent = extractTextFromTextSpan(textSpan);

    expect(textContent, contains('Welcome to RatEat!'));
    expect(textContent, contains('1. Acceptance of Terms'));
    expect(textContent, contains('contact-rateeat@a2sv.org'));
  });
}
