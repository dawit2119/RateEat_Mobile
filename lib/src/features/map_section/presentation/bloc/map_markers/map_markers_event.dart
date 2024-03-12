part of 'map_markers_bloc.dart';

abstract class MapMarkersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMarkersEvent extends MapMarkersEvent {
  final double zoomLevel;
  LoadMarkersEvent({
    required this.zoomLevel,
  });
}
