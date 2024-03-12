import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsObserver extends NavigatorObserver {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _sendScreenView(route: route);
    // debugPrint(route.settings.name);
  }

  Future<void> logLogin(
      {required String method, required Map<String, dynamic> params}) async {
    await _analytics.logLogin(
      loginMethod: method,
      parameters: params.cast<String, Object>(),
    );
  }

  Future<void> logSignUp(
      {required String method, required Map<String, dynamic> params}) async {
    await _analytics.logSignUp(
      signUpMethod: method,
      parameters: params.cast<String, Object>(),
    );
  }

  Future<void> _sendScreenView({required Route<dynamic> route}) async {
    final String? screenName = route.settings.name;
    if (screenName != null) {
      await _analytics.logScreenView(
        screenName: screenName,
      );
    }
  }

  Future<void> sendAnalyticsEvent(
      {required String eventName, required Map<String, dynamic> params}) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: params.cast<String, Object>(),
    );
  }

  Future<void> setUserId({required String userId}) async {
    await _analytics.setUserId(id: userId);
    // debugPrint('setUserId succeeded');
  }

  Future<void> setUserProperty(
      {required String name, required String value}) async {
    await _analytics.setUserProperty(name: name, value: value);
    // debugPrint('setUserProperty succeeded');
  }

  Future<void> setAnalyticsCollectionEnabled() async {
    await _analytics.setAnalyticsCollectionEnabled(false);
    await _analytics.setAnalyticsCollectionEnabled(true);
    // debugPrint('setAnalyticsCollectionEnabled Succeeded');
  }

  Future<void> setAppInstanceId() async {
    // String? id = await _analytics.appInstanceId;
    // debugPrint('appInstanceId succeeded: $id');
  }

  Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
    // debugPrint('resetAnalyticsData succeeded');
  }
}
