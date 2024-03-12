import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/discover/data/data.dart';

import 'get_user_location_dp_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GeolocatorPlatform>(),
  MockSpec<Box>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocationDataProvider locationDataProvider;
  late MockGeolocatorPlatform mockGeolocator;
  late MockBox<double?> mockHiveBox;

  setUp(() {
    mockGeolocator = MockGeolocatorPlatform();
    mockHiveBox = MockBox<double?>();

    // Initialize the LocationDataProvider with mocked classes
    locationDataProvider = LocationDataProvider(
      geolocator: mockGeolocator,
      hiveBox: mockHiveBox,
    );
  });

  group('LocationDataProvider Tests', () {
    test('should return cached location when permissions are denied', () async {
      // Arrange
      when(mockGeolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.denied);
      when(mockGeolocator.requestPermission())
          .thenAnswer((_) async => LocationPermission.denied);
      when(mockHiveBox.get('lastLat')).thenReturn(12.34);
      when(mockHiveBox.get('lastLng')).thenReturn(56.78);

      // Act
      final result = await locationDataProvider.determinePosition();

      // Assert
      expect(result.latitude, 12.34);
      expect(result.longitude, 56.78);
    });

    test('should return error when permissions are permanently denied',
        () async {
      // Arrange
      when(mockGeolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.deniedForever);
      when(mockHiveBox.get('lastLat')).thenReturn(null);
      when(mockHiveBox.get('lastLng')).thenReturn(null);

      // Act & Assert
      expect(
        () async => await locationDataProvider.determinePosition(),
        throwsA(isA<String>()),
      );
    });

    test('should save location to Hive', () async {
      // Arrange
      final position = Position(
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 10.0,
        heading: 10.0,
        speed: 10.0,
        speedAccuracy: 10.0,
        headingAccuracy: 10.0,
        altitudeAccuracy: 10.0,
      );

      when(mockGeolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.whileInUse);
      when(mockGeolocator.getCurrentPosition(
        locationSettings: anyNamed('locationSettings'),
      )).thenAnswer((_) async => position);

      when(mockHiveBox.get('lastLat')).thenReturn(null);
      when(mockHiveBox.get('lastLng')).thenReturn(null);
      when(mockHiveBox.put('lastLat', position.latitude))
          .thenAnswer((_) async => Future.value());
      when(mockHiveBox.put('lastLng', position.longitude))
          .thenAnswer((_) async => Future.value());

      // Act
      await locationDataProvider.determinePosition();

      // Assert
      verify(mockHiveBox.put(captureAny, captureAny)).called(2);
      verify(mockHiveBox.get('lastLat')).called(1);
      verify(mockHiveBox.get('lastLng')).called(1);
    });
  });
}
