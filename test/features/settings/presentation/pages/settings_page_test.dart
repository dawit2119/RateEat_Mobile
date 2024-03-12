import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/settings_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'settings_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CustomAppBar>(),
  MockSpec<AppLocalizations>(),
  MockSpec<AuthenticationLocalSource>()
])
void main() {
  late MockCustomAppBar mockCustomAppBar;
  late MockAppLocalizations mockAppLocalizations;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;

  setUp(() {
    mockCustomAppBar = MockCustomAppBar();
    mockAppLocalizations = MockAppLocalizations();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
      () => MockAuthenticationLocalSource(),
    );
  });

  Widget createTestWidget() {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        SizeConfig().init(context);
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsPage(),
        );
      },
    );
  }

  testWidgets('renders SettingsPage correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byKey(Key('settings_column')), findsOneWidget);
  });

  testWidgets('navigates to Language Preferences on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final languagePreferences = find.text('Select language');
    expect(languagePreferences, findsOneWidget);
  });

  testWidgets('check for Give us feedback', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final logoutButton = find.text('Give us feedback');
    expect(logoutButton, findsOneWidget);
  });
}
