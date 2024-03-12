import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data_sources/map_markers_data_source.dart';
import 'package:rateeat_mobile/src/features/map_section/data/models/map_markers.dart';
import 'package:rateeat_mobile/src/features/map_section/data/repositories/map_markers_repository_impl.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/entities/map_markers.dart';

import 'map_markers_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MapMarkersDataSource>(),
])
void main() {
  late MapMarkersRepositoryImpl repository;
  late MockMapMarkersDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMapMarkersDataSource();
    repository = MapMarkersRepositoryImpl(mapMarkersDataSource: mockDataSource);
  });

  group('MapMarkersRepositoryImpl Tests', () {
    test('loadMarkers returns MapMarkers on success', () async {
      // Arrange
      final expectedMarkers = MapMarkersModel(
          userMarker: BitmapDescriptor.defaultMarker,
          restaurantMarker: BitmapDescriptor.defaultMarker);
      when(mockDataSource.loadMarkers(zoomLevel: anyNamed('zoomLevel')))
          .thenAnswer((_) async => expectedMarkers);

      // Act
      final result = await repository.loadMarkers(zoomLevel: 10.0);

      // Assert
      expect(result, Right(expectedMarkers));
    });

    test('loadMarkers returns Failure on error', () async {
      // Arrange
      when(mockDataSource.loadMarkers(zoomLevel: anyNamed('zoomLevel')))
          .thenThrow(Exception("Failed to load markers"));

      // Act
      final result = await repository.loadMarkers(zoomLevel: 10.0);

      // Assert
      expect(result, isA<Left<Failure, MapMarkers>>());
      expect(result.fold((l) => l.errorMessage, (r) => ''),
          "Failed to load assets");
    });
  });
}
