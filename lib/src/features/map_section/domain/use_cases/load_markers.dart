import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../entities/map_markers.dart';
import '../repositories/map_markers_repository.dart';

class LoadMapMarkersUseCase extends UseCase<MapMarkers, ZoomLevelParams> {
  final MapMarkersRepository mapMarkersRepository;

  LoadMapMarkersUseCase({
    required this.mapMarkersRepository,
  });
  @override
  Future<Either<Failure, MapMarkers>> call(ZoomLevelParams params) async {
    return await mapMarkersRepository.loadMarkers(zoomLevel: params.zoomLevel);
  }
}

class ZoomLevelParams extends Equatable {
  final double zoomLevel;

  const ZoomLevelParams({
    required this.zoomLevel,
  });
  @override
  List<Object?> get props => [zoomLevel];
}
