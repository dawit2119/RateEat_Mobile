import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  group('MapZoomBloc Tests', () {
    late MapZoomBloc mapZoomBloc;

    setUp(() {
      mapZoomBloc = MapZoomBloc();
    });

    tearDown(() {
      mapZoomBloc.close();
    });

    test('initial state is correct', () {
      // Arrange & Act
      final initialState = mapZoomBloc.state;

      // Assert
      expect(initialState.isWalking, true);
      expect(initialState.zoomLevel, 18);
      expect(initialState.isCenterOnUserLocation, false);
      expect(initialState.userLocation, isNull);
    });

    test('changeZoom updates zoom level and walking state', () {
      // Arrange
      final newZoomLevel = 15.0;

      // Act
      mapZoomBloc.changeZoom(zoomLevel: newZoomLevel, isWalking: false);

      // Assert
      expect(mapZoomBloc.state.zoomLevel, newZoomLevel);
      expect(mapZoomBloc.state.isWalking, false);
      expect(mapZoomBloc.state.isCenterOnUserLocation, false);
    });

    test('centerUserLocation updates user location and center state', () {
      // Arrange
      final mockLocation = Location(
          latitude: 12.34,
          longitude: 56.78); // Replace with your actual Location implementation

      // Act
      mapZoomBloc.centerUserLocation(location: mockLocation);

      // Assert
      expect(mapZoomBloc.state.userLocation, mockLocation);
      expect(mapZoomBloc.state.isCenterOnUserLocation, true);
      expect(mapZoomBloc.state.zoomLevel,
          18); // Ensure zoom level remains the same
    });
  });
}
