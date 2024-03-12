import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/widgets/custom_app_bar.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/privacy_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'privacy_page_test.mocks.dart';

class MockLaunchUrl extends Mock {
  Future<void> call(Uri url);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

@GenerateNiceMocks([MockSpec<CustomAppBar>(), MockSpec<AppLocalizations>()])
void main() {
  late MockCustomAppBar mockCustomAppBar;
  late MockAppLocalizations mockAppLocalizations;
  late MockLaunchUrl mockLaunchUrl;

  setUp(() {
    mockCustomAppBar = MockCustomAppBar();
    mockAppLocalizations = MockAppLocalizations();
    mockLaunchUrl = MockLaunchUrl();
  });

  Widget createTestWidget() {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PrivacyPage(),
        );
      },
    );
  }

  testWidgets('renders PrivacyPage correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byKey(Key("privacy_rich_text")), findsOneWidget);
  });
}
