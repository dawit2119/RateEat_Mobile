import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
    ),
  );
  await service.startService();
}

@pragma('vm:entry-point')
Future<bool> onBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Timer to periodically check and send data
  // Timer.periodic(const Duration(seconds: 20), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //     } else {
  //       if (lastSentTime == null) {
  // if (DateTime.now().difference(lastSentTime!) >=
  //     const Duration(seconds: 20)) {
  //   final status = await sendAnalyticsData();
  //   if (status) {
  //     lastSentTime = DateTime.now();
  //     totalSessionDuration = Duration.zero;
  //     await dpLocator<LocalAnalyticsObserver>()
  //         .clearSessionAnalyticsData();
  //   } else {}
  // } else {
  //   final currentTime = DateTime.now();
  //   totalSessionDuration += currentTime.difference(lastSentTime!);
  // }
  //       }
  //     }
  //   }
  // });

  //* background Location getter functions
  // Timer.periodic(const Duration(minutes: 60), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     try {
  //       final position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //         forceAndroidLocationManager: true,
  //       );
  //       final positionData = LocationModel.fromPosition(position);
  //       await locationChangeNotifier(
  //         currentLocation: positionData,
  //       );
  //     } catch (e) {
  //       return;
  //     }
  //   }
  // });
}
