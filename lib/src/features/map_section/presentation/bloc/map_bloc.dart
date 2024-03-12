import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';

class MapZoomState {
  final bool isWalking;
  final double zoomLevel;
  final bool isCenterOnUserLocation;
  final Location? userLocation;

  MapZoomState({
    this.isWalking = true,
    required this.zoomLevel,
    this.userLocation,
    this.isCenterOnUserLocation = false,
  });

  MapZoomState copyWith({
    double? zoomLevel,
    bool? isCenterOnUserLocation,
    Location? userLocation,
    bool? isWalking,
  }) {
    return MapZoomState(
      isWalking: isWalking ?? true,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      isCenterOnUserLocation:
          isCenterOnUserLocation ?? this.isCenterOnUserLocation,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}

class MapZoomBloc extends Cubit<MapZoomState> {
  MapZoomBloc() : super(MapZoomState(zoomLevel: 18));

  void changeZoom({required double zoomLevel, bool? isWalking}) {
    emit(state.copyWith(
      zoomLevel: zoomLevel,
      isCenterOnUserLocation: false,
      userLocation: state.userLocation,
      isWalking: isWalking ?? state.isWalking,
    ));
  }

  void centerUserLocation({required Location location}) {
    emit(state.copyWith(
      userLocation: location,
      zoomLevel: state.zoomLevel,
      isCenterOnUserLocation: true,
    ));
  }
}
