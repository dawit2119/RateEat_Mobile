import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/language/language_bloc.dart';
import 'package:rateeat_mobile/src/core/language/language_event.dart';
import 'package:rateeat_mobile/src/core/language/language_state.dart';
import 'package:rateeat_mobile/src/core/language/language.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/languages.page.dart';

import 'language_page_test.mocks.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

@GenerateNiceMocks([MockSpec<LanguageBloc>(), MockSpec<Box<String>>()])
void main() {
  late MockLanguageBloc mockLanguageBloc;
  late MockBox mockLanguageBox;
  late MockHiveInterface mockHiveInterface;

  setUp(() {
    mockLanguageBloc = MockLanguageBloc();
    mockLanguageBox = MockBox();
    mockHiveInterface = MockHiveInterface();
    // Mock Hive box behavior
    when(mockLanguageBox.get(0)).thenReturn("English");

    // Initial Bloc state
    when(mockLanguageBloc.state)
        .thenReturn(LanguageState(selectedLanguage: Language.english));

    // Mock HiveInterface behavior
    when(mockHiveInterface.isBoxOpen('language')).thenReturn(true);
    when(mockHiveInterface.openBox<String>('language'))
        .thenAnswer((_) async => mockLanguageBox);
  });

  Widget createTestWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<LanguageBloc>(
        create: (context) => mockLanguageBloc as LanguageBloc,
        child: const LanguagesPage(),
      ),
    );
  }

  testWidgets('renders list of languages correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    for (var language in Language.values) {
      expect(find.text(language.text), findsOneWidget);
    }
  });

  testWidgets('displays selected language with check icon',
      (WidgetTester tester) async {
    when(mockLanguageBloc.state)
        .thenReturn(LanguageState(selectedLanguage: Language.amharic));

    await tester.pumpWidget(createTestWidget());

    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('tapping a language updates state and saves to Hive',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final targetLanguage = Language.afaanOromoo;
    final targetTile = find.text(targetLanguage.text);

    expect(targetTile, findsOneWidget);

    await tester.tap(targetTile);
    await tester.pump();

    verify(mockLanguageBloc
            .add(ChangeLanguage(selectedLanguage: targetLanguage)))
        .called(1);
    verify(mockLanguageBox.put(0, targetLanguage.text)).called(1);
  });

  testWidgets('navigates back when app bar is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final backButton = find.byType(IconButton);
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.byType(LanguagesPage), findsNothing);
  });
}
