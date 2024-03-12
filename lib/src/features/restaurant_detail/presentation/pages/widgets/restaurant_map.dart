import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/core.dart';
import '../../../../map_section/presentation/bloc/map_markers/map_markers_bloc.dart';

class RestaurantMapDisplay extends StatefulWidget {
  final RestaurantModel restaurant;
  const RestaurantMapDisplay({super.key, required this.restaurant});

  @override
  State<RestaurantMapDisplay> createState() => _RestaurantMapDisplayState();
}

class _RestaurantMapDisplayState extends State<RestaurantMapDisplay> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  BitmapDescriptor restaurantPin = BitmapDescriptor.defaultMarker;

  GoogleMapController? _googleMapController;

  @override
  void initState() {
    super.initState();
    context.read<MapMarkersBloc>().add(LoadMarkersEvent(zoomLevel: 15));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapMarkersBloc, MapMarkersState>(
        listener: (context, mapMarkerState) {
      if (mapMarkerState is MapMarkersLoaded) {
        restaurantPin = mapMarkerState.mapMarkers.restaurantMarker;
      }
    }, builder: (context, mapMarkerState) {
      return Center(
        child: SizedBox(
          width: 85.h,
          height: 40.w,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: false,
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    onCameraMove: (onCameraMove) {
                      EasyDebounce.debounce(
                          'map-event-debouncer',
                          const Duration(
                            milliseconds: 500,
                          ), () {
                        context.read<MapMarkersBloc>().add(
                            LoadMarkersEvent(zoomLevel: onCameraMove.zoom));
                      });
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId(widget.restaurant.id!),
                        position: LatLng(
                          widget.restaurant.restaurantLocations![0].latitude!,
                          widget.restaurant.restaurantLocations![0].longitude!,
                        ),
                        onTap: () {
                          try {
                            var userLocation = context.read<UserLocationBloc>()
                                as UserLocationLoaded;
                            _launchDirections(
                                startPoint: userLocation.location,
                                destinationPoint: Location(
                                  latitude: widget.restaurant
                                      .restaurantLocations![0].latitude!,
                                  longitude: widget.restaurant
                                      .restaurantLocations![0].longitude!,
                                ));
                          } catch (e) {
                            // showCustomToast(
                            //     context: context,
                            //     toastMessage: "Getting location data");
                          }
                        },
                      ),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                      _googleMapController = controller;
                      // controller.setMapStyle(mapStyle);
                    },
                    style: mapStyle,
                    minMaxZoomPreference: const MinMaxZoomPreference(12, 20),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.restaurant.restaurantLocations![0].latitude!,
                        widget.restaurant.restaurantLocations![0].longitude!,
                      ),
                      zoom: 14.4746,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 7.h,
                  right: 3.w,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey300,
                          blurRadius: 0.8,
                          offset: Offset.fromDirection(1.57, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      child: const Icon(Icons.add),
                      onTap: () async {
                        _googleMapController!.animateCamera(
                          CameraUpdate.zoomIn(),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1.8.h,
                  right: 3.w,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey300.withOpacity(0.6),
                          blurRadius: 0.8,
                          offset: Offset.fromDirection(1.57, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      child: const Icon(Icons.remove),
                      onTap: () async {
                        _googleMapController!.animateCamera(
                          CameraUpdate.zoomOut(),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1.8.h,
                  left: 3.w,
                  child: GestureDetector(
                    onTap: () {
                      _googleMapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(
                              widget
                                  .restaurant.restaurantLocations![0].latitude!,
                              widget.restaurant.restaurantLocations![0]
                                  .longitude!,
                            ),
                          ),
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        var userLocation = context
                            .read<UserLocationBloc>()
                            .state as UserLocationLoaded;
                        _launchDirections(
                          startPoint: userLocation.location,
                          destinationPoint: Location(
                            latitude: widget
                                .restaurant.restaurantLocations![0].latitude!,
                            longitude: widget
                                .restaurant.restaurantLocations![0].longitude!,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1.h,
                          horizontal: 3.w,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              5,
                            ),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Iconsax.map,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "View on map",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _launchDirections({
    required Location startPoint,
    required Location destinationPoint,
  }) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${startPoint.latitude},${startPoint.longitude}&destination=${destinationPoint.latitude},${destinationPoint.longitude}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
