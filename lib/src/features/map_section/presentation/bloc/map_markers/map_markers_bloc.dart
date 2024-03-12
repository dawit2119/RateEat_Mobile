import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/map_markers.dart';
import '../../../domain/use_cases/load_markers.dart';

part 'map_markers_event.dart';
part 'map_markers_state.dart';

class MapMarkersBloc extends Bloc<MapMarkersEvent, MapMarkersState> {
  final LoadMapMarkersUseCase loadMarkersUseCase;
  MapMarkersBloc({
    required this.loadMarkersUseCase,
  }) : super(MapMarkerInitial()) {
    on<LoadMarkersEvent>(_onLoadMapMarkersEvent);
  }
  void _onLoadMapMarkersEvent(
      LoadMarkersEvent event, Emitter<MapMarkersState> emit) async {
    try {
      emit(
        MapMarkersLoading(),
      );
      final response =
          await loadMarkersUseCase(ZoomLevelParams(zoomLevel: event.zoomLevel));

      response.fold(
        (l) => emit(
          MapMarkersLoadingFailed(),
        ),
        (markers) => emit(
          MapMarkersLoaded(
            mapMarkers: markers,
          ),
        ),
      );
    } catch (e) {
      emit(
        MapMarkersLoadingFailed(),
      );
    }
  }
}
