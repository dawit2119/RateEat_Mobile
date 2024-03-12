import 'dart:math';

import '../../../features.dart';

class DistanceCalculator {
  static const double walkingSpeedMetersPerMinute =
      80 / 60; // 80 meters per minute
  static const double drivingSpeedMetersPerMinute =
      1000 / 60; // 1500 meters per minute

  double walkingDistance(Duration time) {
    final minutes = time.inMinutes;
    final distance = walkingSpeedMetersPerMinute * minutes;
    return distance;
  }

  drivingDistance(Duration time) {
    final minutes = time.inMinutes;
    final distance = drivingSpeedMetersPerMinute * minutes;
    return distance;
  }

  double zoomLevelToDistance({required double zoomLevel}) {
    double earthCircumferenceMeters =
        40075016.686; // Earth's circumference at the equator in meters
    // double distanceInMeters = earthCircumferenceMeters /
    // (1 << zoomLevel.toInt());
    double distanceInMeters = earthCircumferenceMeters *
        (earthCircumferenceMeters / pow(2, zoomLevel));
    return distanceInMeters;
  }

  double distanceToZoomLevel({required double distanceInMeters}) {
    double earthCircumferenceMeters =
        40075016.686; // Earth's circumference at the equator in meters
    double zoomLevel =
        log(earthCircumferenceMeters / (distanceInMeters * 2 * pi)) / log(2);
    return zoomLevel;
  }

  double zoomLevelToWalkingTime({required double zoomLevel}) {
    double distanceInMeters = zoomLevelToDistance(zoomLevel: zoomLevel);
    double walkingSpeedMetersPerMinute = 80.0;
    double walkingTimeMinutes = distanceInMeters / walkingSpeedMetersPerMinute;
    return walkingTimeMinutes;
  }

  double zoomLevelToDrivingTime({required double zoomLevel}) {
    double distanceInMeters = zoomLevelToDistance(zoomLevel: zoomLevel);
    double drivingSpeedMetersPerMinute = 1000.0;
    double drivingTimeMinutes = distanceInMeters / drivingSpeedMetersPerMinute;
    return drivingTimeMinutes;
  }

  Duration getWalkingTime(Location origin, Location destination) {
    // Calculate the straight-line (as-the-crow-flies) distance between origin and destination.
    final double distanceInMeters =
        calculateStraightLineDistance(origin, destination);
    // Calculate the time required to walk the distance at walking speed.
    const double walkingSpeedMetersPerMinute = 80.0; // 80 meters per minute
    final double walkingTimeInMinutes =
        distanceInMeters / walkingSpeedMetersPerMinute;

    return Duration(minutes: walkingTimeInMinutes.round());
  }

  Duration getDrivingTime(Location origin, Location destination) {
    // Calculate the straight-line (as-the-crow-flies) distance between origin and destination.
    final double distanceInMeters =
        calculateStraightLineDistance(origin, destination);
    // Calculate the time required to walk the distance at walking speed.
    const double drivingSpeedMetersPerMinute = 1000.0; // 1500 meters per minute
    final double drivingTimeInMinutes =
        distanceInMeters / drivingSpeedMetersPerMinute;

    return Duration(minutes: drivingTimeInMinutes.round());
  }

  double calculateStraightLineDistance(Location origin, Location destination) {
    final double lat1 = degreesToRadians(origin.latitude);
    final double lon1 = degreesToRadians(origin.longitude);
    final double lat2 = degreesToRadians(destination.latitude);
    final double lon2 = degreesToRadians(destination.longitude);

    const double earthRadiusKm = 6371.0; // Radius of the Earth in kilometers
    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double distance = earthRadiusKm * c * 1000; // Convert to meters

    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
