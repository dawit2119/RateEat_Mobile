part of 'map_markers_bloc.dart';

abstract class MapMarkersState extends Equatable {
  @override
  List<Object> get props => [];
}

final class MapMarkerInitial extends MapMarkersState {}

final class MapMarkersLoading extends MapMarkersState {}

final class MapMarkersLoadingFailed extends MapMarkersState {}

final class MapMarkersLoaded extends MapMarkersState {
  final MapMarkers mapMarkers;

  MapMarkersLoaded({
    required this.mapMarkers,
  });
  @override
  List<Object> get props => [mapMarkers];
}
