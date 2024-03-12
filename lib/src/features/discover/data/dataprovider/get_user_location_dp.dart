import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/discover/data/models/location_model.dart';

class LocationDataProvider {
  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  final GeolocatorPlatform geolocator;
  final Box<double?> hiveBox;

  // Constructor with optional parameters
  LocationDataProvider({
    GeolocatorPlatform? geolocator,
    Box<double?>? hiveBox,
  })  : geolocator = geolocator ?? GeolocatorPlatform.instance,
        hiveBox = hiveBox ?? Hive.box<double?>('locationBox');

  Future<LocationModel> determinePosition() async {
    //* location from cache
    final prevSavedLocation = getLocationFromHive();

    LocationPermission permission;
    permission = await geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        if (prevSavedLocation != null) {
          return prevSavedLocation;
        }
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      if (prevSavedLocation != null) {
        return prevSavedLocation;
      }
      return Future.error('Location permissions are permanently denied');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var location = await geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
      // forceAndroidLocationManager: true,
    );
    //* save last known location
    await saveLocationToHive(
        latitude: location.latitude, longitude: location.longitude);

    return LocationModel.fromPosition(location);
  }

  LocationModel? getLocationFromHive() {
    try {
      double? lastLat = hiveBox.get('lastLat');
      double? lastLng = hiveBox.get('lastLng');
      if (lastLng != null) {
        return LocationModel(latitude: lastLat!, longitude: lastLng);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveLocationToHive(
      {required double latitude, required double longitude}) async {
    try {
      await hiveBox.put('lastLat', latitude);
      await hiveBox.put('lastLng', longitude);
    } catch (e) {
      return;
    }
  }
}
