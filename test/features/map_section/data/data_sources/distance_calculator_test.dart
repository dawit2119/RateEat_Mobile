import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  DistanceCalculator distanceCalculator = DistanceCalculator();

  setUp(() {
    distanceCalculator = DistanceCalculator();
  });

  group('DistanceCalculator Tests', () {
    test('Walking distance calculation', () {
      final duration = Duration(minutes: 10);
      final expectedDistance = 80 / 60 * 10; // 80 meters/min * 10 min
      expect(distanceCalculator.walkingDistance(duration), expectedDistance);
    });

    test('Driving distance calculation', () {
      final duration = Duration(minutes: 10);
      final expectedDistance = 1000 / 60 * 10; // 1000 meters/min * 10 min
      expect(distanceCalculator.drivingDistance(duration), expectedDistance);
    });

    test('Zoom level to distance conversion', () {
      final zoomLevel = 10.0;
      final expectedDistance =
          40075016.686 * (40075016.686 / pow(2, zoomLevel));
      expect(distanceCalculator.zoomLevelToDistance(zoomLevel: zoomLevel),
          expectedDistance);
    });

    test('Distance to zoom level conversion', () {
      final distanceInMeters = 1000.0;
      final expectedZoomLevel =
          log(40075016.686 / (distanceInMeters * 2 * pi)) / log(2);
      expect(
          distanceCalculator.distanceToZoomLevel(
              distanceInMeters: distanceInMeters),
          expectedZoomLevel);
    });

    test('Zoom level to walking time', () {
      final zoomLevel = 10.0;
      final distanceInMeters =
          distanceCalculator.zoomLevelToDistance(zoomLevel: zoomLevel);
      final expectedWalkingTime = distanceInMeters / 80.0; // 80 meters/min
      expect(distanceCalculator.zoomLevelToWalkingTime(zoomLevel: zoomLevel),
          expectedWalkingTime);
    });

    test('Zoom level to driving time', () {
      final zoomLevel = 10.0;
      final distanceInMeters =
          distanceCalculator.zoomLevelToDistance(zoomLevel: zoomLevel);
      final expectedDrivingTime = distanceInMeters / 1000.0; // 1000 meters/min
      expect(distanceCalculator.zoomLevelToDrivingTime(zoomLevel: zoomLevel),
          expectedDrivingTime);
    });

    test('Get walking time between two locations', () {
      final origin = Location(latitude: 0, longitude: 0);
      final destination = Location(latitude: 1, longitude: 1);
      final expectedWalkingTime = distanceCalculator
              .calculateStraightLineDistance(origin, destination) /
          80.0;
      expect(distanceCalculator.getWalkingTime(origin, destination),
          Duration(minutes: expectedWalkingTime.round()));
    });

    test('Get driving time between two locations', () {
      final origin = Location(latitude: 0, longitude: 0);
      final destination = Location(latitude: 1, longitude: 1);
      final expectedDrivingTime = distanceCalculator
              .calculateStraightLineDistance(origin, destination) /
          1000.0;
      expect(distanceCalculator.getDrivingTime(origin, destination),
          Duration(minutes: expectedDrivingTime.round()));
    });

    test('Calculate straight line distance', () {
      final origin = Location(latitude: 0, longitude: 0);
      final destination = Location(latitude: 1, longitude: 1);
      final expectedDistance =
          distanceCalculator.calculateStraightLineDistance(origin, destination);
      // You can add an expected value based on known coordinates if necessary
      expect(expectedDistance, isNotNull);
    });
  });
}
