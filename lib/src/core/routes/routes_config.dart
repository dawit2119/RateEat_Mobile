import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:upgrader/upgrader.dart';
import '../../../l10n/gen_l10n/app_localizations.dart';
import '../../features/authentication/authentication.dart';
import '../core.dart';
import '../language/language_bloc.dart';
import '../language/language_state.dart';
import '../service/firebase_analytics.dart';

class FallbackMaterialLocalizations extends DefaultMaterialLocalizations {
  const FallbackMaterialLocalizations();
}

class FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Add all unsupported locales here
    return ['rw', 'ar', 'ti', 'so', 'rn', 'lg'].contains(locale.languageCode);
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const FallbackMaterialLocalizations();
  }

  @override
  bool shouldReload(FallbackMaterialLocalizationsDelegate old) => false;
}

class AppRouter extends StatelessWidget {
  static final GoRouter router = createRoute();
  final AuthenticationLocalSource localSource;
  static Future<String?> redirect(
      BuildContext context, GoRouterState state) async {
    try {
      final authState = context.read<AuthenticationBloc>().state;
      final path = state.uri.toString();
      if (path.startsWith('/mobileShare')) {
        final newPath = path.replaceFirst('/mobileShare', '');

        return newPath;
      }
      if (authState is VerifyEmailOtpState &&
          authState.status == AuthStatus.loaded) {
        return '/';
      }
      return null;
    } on CacheException {
      debugPrint("cache exception from path ${state.uri.toString()}");
    }
    return null;
  }

  static GoRouter createRoute() {
    return GoRouter(
      redirect: ((context, state) => redirect(context, state)),
      initialLocation: "/splash",
      routes: routes,
      observers: [
        AnalyticsObserver(),
        LocalAnalyticsObserver(),
      ],
    );
  }

  AppRouter({super.key, required this.localSource}) {
    (context, state) => MaterialPage(
          key: const ValueKey('errorPage'),
          child: Scaffold(
            body: Center(
              child: Text(
                AppLocalizations.of(context)!.pageNotFoundText,
              ),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return Directionality(
            textDirection:
                languageState.selectedLanguage.value.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            child: MaterialApp.router(
              builder: (context, child) => UpgradeAlert(
                child: FToastBuilder()(context, child),
              ),
              debugShowCheckedModeBanner: false,
              locale: languageState.selectedLanguage.value,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: [
                ...AppLocalizations.localizationsDelegates,
                const FallbackMaterialLocalizationsDelegate(),
              ],
              title: 'RateEat Mobile',
              theme: lightTheme,
              routerConfig: router,
            ),
          );
        },
      ),
    );
  }
}
