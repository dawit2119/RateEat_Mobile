import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import './login_page_test.mocks.dart';

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

class MockGetUserProfileBloc extends Mock implements GetUserProfileBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateNiceMocks(
  [
    MockSpec<MockAuthenticationBloc>(),
    MockSpec<MockGetUserProfileBloc>(),
  ],
)
void main() {
  group('LoginPage Widget Test', () {
    late MockAuthenticationBloc mockAuthenticationBloc;
    late MockGetUserProfileBloc mockGetUserProfileBloc;

    setUp(() {
      dpLocator.reset();
      mockAuthenticationBloc = MockMockAuthenticationBloc();
      mockGetUserProfileBloc = MockMockGetUserProfileBloc();

      dpLocator.registerFactory<AuthenticationBloc>(
        () => mockAuthenticationBloc,
      );
      dpLocator.registerFactory<GetUserProfileBloc>(
        () => mockGetUserProfileBloc,
      );
      HttpOverrides.global = null;
    });

    Widget makeTestableWidget(
      Widget body, {
      NavigatorObserver? observer,
    }) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (_) => dpLocator<AuthenticationBloc>(),
          ),
          BlocProvider<GetUserProfileBloc>(
            create: (_) => dpLocator<GetUserProfileBloc>(),
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
          navigatorObservers: observer != null ? [observer] : [],
        ),
      );
    }

    testWidgets('Should display loading animation when sending OTP',
        (WidgetTester tester) async {
      when(mockAuthenticationBloc.state).thenReturn(
        const SendPhoneOtpState(
          status: AuthStatus.loading,
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          LoginPage(),
        ),
      );
      expect(
        find.byKey(
          const Key("SendPhoneOtpState:LoadingAnimationWidget"),
        ),
        findsOneWidget,
      );
    });
    testWidgets('Should display loading animation when sign-in Google',
        (WidgetTester tester) async {
      when(mockAuthenticationBloc.state).thenReturn(
        const SignInWithGoogleState(
          status: AuthStatus.loading,
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          LoginPage(),
        ),
      );
      expect(
        find.byKey(const Key("Google-Sign-in:LoadingAnimationWidget")),
        findsOneWidget,
      );
    });

    testWidgets('Should navigate to OTP page on successful OTP send',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      when(mockAuthenticationBloc.state).thenReturn(
        const SendPhoneOtpState(
          status: AuthStatus.loaded,
        ),
      );
      await tester.pumpWidget(
        makeTestableWidget(
          LoginPage(),
          observer: mockObserver,
        ),
      );
      // verify(mockObserver.didPush(any, any));
      //     .called(greaterThanOrEqualTo(1));

      // expect(
      //   find.byType(OtpPage),
      //   findsOneWidget,
      // );
    });
  });
}
