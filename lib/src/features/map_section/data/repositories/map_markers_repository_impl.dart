import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../domain/entities/map_markers.dart';
import '../../domain/repositories/map_markers_repository.dart';
import '../data_sources/map_markers_data_source.dart';

class MapMarkersRepositoryImpl implements MapMarkersRepository {
  final MapMarkersDataSource mapMarkersDataSource;

  MapMarkersRepositoryImpl({
    required this.mapMarkersDataSource,
  });
  @override
  Future<Either<Failure, MapMarkers>> loadMarkers(
      {required double zoomLevel}) async {
    try {
      final markers =
          await mapMarkersDataSource.loadMarkers(zoomLevel: zoomLevel);
      return Right(markers);
    } catch (e) {
      return Left(
        DefaultFailure(errorMessage: "Failed to load assets"),
      );
    }
  }
}
