import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif/gif.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import 'package:rateeat_mobile/src/features/splash/presentation/pages/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'onboard_widget_test.mocks.dart';

class mockNetworkBloc extends Mock implements NetworkBloc {}

@GenerateNiceMocks([MockSpec<mockNetworkBloc>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('onboard screen', () {
    late mockNetworkBloc mockNet;
    setUp(() {
      mockNet = MockmockNetworkBloc();
    });
    dpLocator.registerFactory<NetworkBloc>(() => mockNet);

    HttpOverrides.global = null;

    Widget makeTestableWidget(Widget body) {
      return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => dpLocator<NetworkBloc>()),
          ],
          child: MaterialApp(
            locale: const Locale('en', 'US'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: ResponsiveSizer(builder: (context, orientation, screenType) {
              return body;
            }),
          ));
    }

    testWidgets('OnboardingScreen renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(const SplashScreen()));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Gif), findsOneWidget);
    });

    testWidgets('OnboardingScreen when network failed',
        (WidgetTester tester) async {
      when(mockNet.stream).thenAnswer((_) => const Stream.empty());
      when(mockNet.state).thenAnswer((_) => NetworkFailed());

      await tester.pumpWidget(makeTestableWidget(const SplashScreen()));

      expect(find.byType(CustomMainButton), findsOneWidget);
    });

    testWidgets('OnboardingScreen when network is loading',
        (WidgetTester tester) async {
      when(mockNet.stream).thenAnswer((_) => const Stream.empty());
      when(mockNet.state).thenAnswer((_) => NetworkSuccess());

      await tester.pumpWidget(makeTestableWidget(const SplashScreen()));

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
