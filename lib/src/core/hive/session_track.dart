import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/service/firebase_performance.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import '../../features/background_processing/data/background_processing_api.dart';

part 'session_track.g.dart';

@HiveType(typeId: 4)
class UserSession {
  @HiveField(0)
  DateTime startTime;

  @HiveField(1)
  DateTime? endTime;

  @HiveField(2)
  int totalSessionTime;

  @HiveField(3)
  DateTime sessionStartDate;

  UserSession({
    required this.startTime,
    this.totalSessionTime = 0,
    this.endTime,
    required this.sessionStartDate,
  });

  @override
  String toString() {
    return 'UserSession{'
        'startTime: $startTime, '
        'endTime: $endTime, '
        'totalSessionTime: $totalSessionTime, '
        'sessionStartDate: $sessionStartDate'
        '}';
  }
}

Future<void> startSession() async {
  final userSessionBox = await Hive.openBox<UserSession>('user_sessions');
  final newSession = UserSession(
    startTime: DateTime.now(),
    sessionStartDate: DateTime.now(),
  );
  await userSessionBox.put('session', newSession);
}

Future<void> pauseSession() async {
  final userSessionBox = await Hive.openBox<UserSession>('user_sessions');
  final session = userSessionBox.get('session');

  if (session != null) {
    final currentTime = DateTime.now();
    final prevTotalTime = session.totalSessionTime;
    final diff = (currentTime.difference(session.startTime)).inSeconds;
    session.totalSessionTime = prevTotalTime + diff;
    session.startTime = DateTime.now();
    await userSessionBox.put('session', session);
  }
}

Future<void> resumeSession() async {
  final userSessionBox = await Hive.openBox<UserSession>('user_sessions');
  final session = userSessionBox.get('session');

  if (session != null) {
    final currentTime = DateTime.now();
    final diff = (currentTime.difference(session.startTime)).inSeconds;
    if (diff > 60) {
      final response = await sendData();
      if (response) {
        await startSession();
      } else {
        session.startTime = DateTime.now();
        await userSessionBox.put('session', session);
      }
    } else {
      session.startTime = DateTime.now();
      await userSessionBox.put('session', session);
    }
  } else {
    await startSession();
  }
}

Future<bool> sendData() async {
  //* The Authorized  User
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  final userManagement = dpLocator<LocalAnalyticsObserver>();

  if (user == null) return true;
  final userSessionBox = await Hive.openBox<UserSession>('user_sessions');
  final session = userSessionBox.get('session');
  try {
    if (session != null) {
      final performanceTester =
          dpLocator<FirebasePerformanceTracker>().getPerformanceTracker();
      final trace = performanceTester.newTrace("background_analytics");
      trace.start();
      final status = await sendAnalyticsData();
      trace.stop();
      session.endTime = DateTime.now();
      await userSessionBox.put('session', session);
      if (status) {
        await userManagement.clearSessionAnalyticsData();
      }
      return status;
    }
    return false;
  } catch (e) {
    return false;
  }
}
