import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';

import '../../features/authentication/authentication.dart';
import '../../features/notification/presentation/bloc/fetch_notifications/notification_bloc.dart';
import '../core.dart';

class PushNotificationsAPI {
  //create instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  //initiate notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      //Fetch the FCM token for this device
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/round_launcher');
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (details) {
        final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
        if (user != null) {
          AppRouter.router.pushReplacementNamed(AppRoutes.notificationPage,
              extra: {"user": user});
        }
      });
      final token = await _firebaseMessaging.getToken();
      final appLaunchStateBox = Hive.box<String>('fcmTokenBox');
      appLaunchStateBox.put("fcmToken", token ?? "");
      initPushNotifications();
    } catch (e) {
      log("Error in Push Notifications API: $e");
    }
  }

  void handleForegroundNotification(RemoteMessage message) {
    // Define the notification details
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    flutterLocalNotificationsPlugin.show(
        0, // notification id
        message.notification?.title, // title
        message.notification?.body, // body
        platformChannelSpecifics,
        payload: 'item x');
  }

  //handle messages
  void handleMessages(RemoteMessage? message) {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (message == null || user == null) return;
    var notificationBloc = dpLocator<NotificationsBloc>();
    notificationBloc.add(
      GetUserNotifications(
        userId: user.id!,
      ),
    );
    AppRouter.router.goNamed(AppRoutes.splash, extra: {
      "notification": message,
      "userId": user.id!,
    });
  }

  //function to initiate foreground and background messages
  Future initPushNotifications() async {
    // handle notifications if the app was terminated and now opened
    _firebaseMessaging.getInitialMessage().then(handleMessages);
    //attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
    FirebaseMessaging.onMessage.listen(handleForegroundNotification);
  }
}
