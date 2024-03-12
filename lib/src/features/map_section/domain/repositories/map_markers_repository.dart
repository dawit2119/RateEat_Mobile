import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/map_markers.dart';

abstract class MapMarkersRepository {
  Future<Either<Failure, MapMarkers>> loadMarkers({required double zoomLevel});
}
