import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class FirebaseCrashLogger {
  final FirebaseCrashlytics _logger = FirebaseCrashlytics.instance;
  FirebaseCrashlytics getCrashLogger() => _logger;

  Future<void> log({required String message}) async {
    await _logger.log(message);
    // debugPrint('logEvent succeeded');
  }

  Future<void> setCustomKeys(
      {required String key, required String value}) async {
    await _logger.setCustomKey(
      key,
      value,
    );
  }

  Future<void> setUserIdentifier({required String userId}) async {
    await _logger.setUserIdentifier(userId);
  }

  Future<void> recordError({
    required dynamic error,
    StackTrace? stack,
    required String reason,
    required Iterable<Object> information,
  }) async {
    await _logger.recordError(
      error,
      stack,
      reason: reason,
      information: information,
    );
  }
}

Future<void> initializeCrashLog() async {
  try {
    const fatalError = true;
    // Non-async exceptions
    FlutterError.onError = (errorDetails) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      }
    };
    // Async exceptions
    PlatformDispatcher.instance.onError = (error, stack) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
      return true;
    };
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } catch (e) {
    debugPrint('Error initializing Crashlytics: $e');
  }
}
