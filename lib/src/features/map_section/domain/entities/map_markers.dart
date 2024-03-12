import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkers extends Equatable {
  final BitmapDescriptor userMarker;
  final BitmapDescriptor restaurantMarker;

  const MapMarkers({
    required this.userMarker,
    required this.restaurantMarker,
  });

  @override
  List<Object?> get props => [
        userMarker,
        restaurantMarker,
      ];
}
