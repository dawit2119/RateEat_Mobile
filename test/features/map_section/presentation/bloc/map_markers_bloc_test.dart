import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/entities/map_markers.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/use_cases/load_markers.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/map_markers/map_markers_bloc.dart';

import 'map_markers_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoadMapMarkersUseCase>(),
])
void main() {
  late MapMarkersBloc mapMarkersBloc;
  late MockLoadMapMarkersUseCase mockLoadMarkersUseCase;

  setUp(() {
    mockLoadMarkersUseCase = MockLoadMapMarkersUseCase();
    mapMarkersBloc = MapMarkersBloc(loadMarkersUseCase: mockLoadMarkersUseCase);
  });

  tearDown(() {
    mapMarkersBloc.close();
  });

  group('MapMarkersBloc Tests', () {
    test('initial state is MapMarkerInitial', () {
      // Arrange & Act
      final initialState = mapMarkersBloc.state;

      // Assert
      expect(initialState, isA<MapMarkerInitial>());
    });

    test(
        'emits [MapMarkersLoading, MapMarkersLoaded] when LoadMarkersEvent is added',
        () async {
      // Arrange
      final markers = MapMarkers(
          userMarker: BitmapDescriptor.defaultMarker,
          restaurantMarker: BitmapDescriptor.defaultMarker);
      when(mockLoadMarkersUseCase(any)).thenAnswer((_) async => Right(markers));

      // Act
      mapMarkersBloc.add(LoadMarkersEvent(zoomLevel: 10.0));

      // Assert
      expectLater(
        mapMarkersBloc.stream,
        emitsInOrder([
          isA<MapMarkersLoading>(),
          isA<MapMarkersLoaded>()
              .having((state) => state.mapMarkers, 'mapMarkers', markers),
        ]),
      );
    });

    test(
        'emits [MapMarkersLoading, MapMarkersLoadingFailed] when LoadMarkersEvent fails',
        () async {
      // Arrange
      when(mockLoadMarkersUseCase(any)).thenAnswer((_) async =>
          Left(ServerFailure(errorMessage: "Failed to load markers")));

      // Act
      mapMarkersBloc.add(LoadMarkersEvent(zoomLevel: 10.0));

      // Assert
      expectLater(
        mapMarkersBloc.stream,
        emitsInOrder([
          isA<MapMarkersLoading>(),
          isA<MapMarkersLoadingFailed>(),
        ]),
      );
    });

    test('emits [MapMarkersLoading, MapMarkersLoadingFailed] on exception',
        () async {
      // Arrange
      when(mockLoadMarkersUseCase(any))
          .thenThrow(Exception("Unexpected error"));

      // Act
      mapMarkersBloc.add(LoadMarkersEvent(zoomLevel: 10.0));

      // Assert
      expectLater(
        mapMarkersBloc.stream,
        emitsInOrder([
          isA<MapMarkersLoading>(),
          isA<MapMarkersLoadingFailed>(),
        ]),
      );
    });
  });
}
