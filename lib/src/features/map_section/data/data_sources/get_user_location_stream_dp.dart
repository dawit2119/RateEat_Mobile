import 'dart:async';

import 'package:geolocator/geolocator.dart';

const LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);
StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {});
