import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/map_markers.dart';

abstract class MapMarkersDataSource {
  Future<MapMarkersModel> loadMarkers({required double zoomLevel});
}

class MapMarkersDataSourceImpl implements MapMarkersDataSource {
  MapMarkersDataSourceImpl();
  @override
  Future<MapMarkersModel> loadMarkers({required double zoomLevel}) =>
      _loadMarkers(zoomLevel: zoomLevel);

  Future<MapMarkersModel> _loadMarkers({required double zoomLevel}) async {
    try {
      final userLocationPin = await getMarker(
        imagePath: "assets/icons/map_pin_user_blue.png",
        isLocationPin: true,
        zoomLevel: zoomLevel,
      );

      final restaurantLocationPin = await getMarker(
        imagePath: "assets/icons/map_pin_item.png",
        zoomLevel: zoomLevel,
      );
      return MapMarkersModel(
        userMarker: userLocationPin,
        restaurantMarker: restaurantLocationPin,
      );
    } catch (e) {
      throw Exception("Failed to fetch icons");
    }
  }
}

Future<ui.Image> _loadMarkerImage(String imagePath) async {
  try {
    final ByteData data = await rootBundle.load(imagePath);
    final bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    return image;
  } catch (e) {
    throw Exception();
  }
}

// Create a custom marker with dynamic size based on the zoom level
Future<BitmapDescriptor> getMarker({
  required String imagePath,
  bool isLocationPin = false,
  double zoomLevel = 18,
}) async {
  // Adjust the marker size based on the zoom level
  try {
    Size locationPinSize = Size((zoomLevel - 2) * 2, (zoomLevel - 2) * 2);
    Size restaurantPinSize = Size((zoomLevel - 2) * 1.8, (zoomLevel - 2) * 2);

    // Load the custom marker image
    ui.Image markerImage = await _loadMarkerImage(imagePath);

    // Resize the marker image
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(
      uint8List,
      targetHeight: isLocationPin
          ? locationPinSize.height.toInt()
          : restaurantPinSize.height.toInt(),
      targetWidth: isLocationPin
          ? locationPinSize.width.toInt()
          : restaurantPinSize.width.toInt(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final ByteData? resizedByteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedBytes = resizedByteData!.buffer.asUint8List();

    final BitmapDescriptor resizedMarker = BitmapDescriptor.bytes(resizedBytes);

    return resizedMarker;
  } catch (e) {
    throw Exception();
  }
}
