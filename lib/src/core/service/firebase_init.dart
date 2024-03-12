import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rateeat_mobile/firebase_options.dart';
import 'package:rateeat_mobile/src/core/service/firebase_crachlytics.dart';

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); // Initialize other Firebase services if needed
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    await initializeCrashLog();
  } catch (e) {
    //  print(e.toString());
  }
}
