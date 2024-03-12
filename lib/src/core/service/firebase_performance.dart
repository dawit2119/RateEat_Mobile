import 'package:firebase_performance/firebase_performance.dart';

class FirebasePerformanceTracker {
  final FirebasePerformance _tracker = FirebasePerformance.instance;
  FirebasePerformance getPerformanceTracker() => _tracker;

  Trace createTrace({required String name}) {
    return _tracker.newTrace(name);
  }
}
