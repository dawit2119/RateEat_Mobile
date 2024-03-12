import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/dp_injection/dependency_injection.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import './otp_page_test.mocks.dart';

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

@GenerateNiceMocks([
  MockSpec<MockAuthenticationBloc>(),
])
void main() {
  group('OtpPage Widget Test', () {
    late MockAuthenticationBloc mockAuthenticationBloc;
    late Map<String, dynamic> previousRouteInfo;
    setUp(() {
      dpLocator.reset();
      mockAuthenticationBloc = MockMockAuthenticationBloc();
      previousRouteInfo = const {"phoneNumber": "+2519000000000"};

      dpLocator.registerFactory<AuthenticationBloc>(
        () => mockAuthenticationBloc,
      );
      HttpOverrides.global = null;
    });

    Widget makeTestableWidget(Widget body) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (_) => mockAuthenticationBloc,
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en', 'US'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ResponsiveSizer(
            builder: (context, orientation, screenType) {
              return body;
            },
          ),
        ),
      );
    }

    testWidgets('Should display SingleChildScrollView when the page is ready',
        (WidgetTester tester) async {
      when(mockAuthenticationBloc.state).thenReturn(
        const VerifyOtpState(
          status: AuthStatus.loading,
        ),
      );

      await tester.pumpWidget(makeTestableWidget(OtpPage(
        previousRouteInfo: previousRouteInfo,
      )));
      expect(
        find.byType(SingleChildScrollView),
        findsOneWidget,
      );
    });

    testWidgets('Should display Loading indicator while sending OTP',
        (WidgetTester tester) async {
      when(mockAuthenticationBloc.state).thenReturn(
        const VerifyOtpState(
          status: AuthStatus.loading,
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          OtpPage(
            previousRouteInfo: previousRouteInfo,
          ),
        ),
      );
      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    });

    testWidgets('Should navigate to home on successful OTP verification',
        (WidgetTester tester) async {
      when(mockAuthenticationBloc.state)
          .thenReturn(const VerifyOtpState(status: AuthStatus.loaded));

      await tester.pumpWidget(
        makeTestableWidget(
          OtpPage(
            previousRouteInfo: previousRouteInfo,
          ),
        ),
      );
    });
  });
}
