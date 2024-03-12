import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/map_markers/map_markers_bloc.dart';

import '../../../../core/core.dart';
import '../../../discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import '../../../features.dart';
import 'restaurant_info_bottom_sheet_sliver.dart';

class GoogleMapContent extends StatefulWidget {
  const GoogleMapContent({super.key});

  @override
  State<GoogleMapContent> createState() => _MapContentState();
}

class _MapContentState extends State<GoogleMapContent>
    with TickerProviderStateMixin {
  DistanceCalculator distanceCalculator = DistanceCalculator();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  BitmapDescriptor restaurantsMarkers = BitmapDescriptor.defaultMarker;
  BitmapDescriptor userMarker = BitmapDescriptor.defaultMarker;
  List<Restaurant>? restaurants;

  @override
  void initState() {
    super.initState();
    context.read<MapMarkersBloc>().add(
          LoadMarkersEvent(
            zoomLevel: 18,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLocationBloc, UserLocationState>(
      builder: (context, userLocationState) {
        if (userLocationState is UserLocationLoaded) {
          context.read<DiscoveryStepsBloc>().add(
                DiscoveryFilterUpdate(
                  latitude: userLocationState.location.latitude,
                  longitude: userLocationState.location.longitude,
                ),
              );

          return BlocConsumer<MapZoomBloc, MapZoomState>(
            listener: (context, zoomState) {
              EasyDebounce.debounce(
                  'map-event-debouncer',
                  const Duration(
                    milliseconds: 500,
                  ), () {
                context.read<MapMarkersBloc>().add(
                      LoadMarkersEvent(
                        zoomLevel: zoomState.zoomLevel,
                      ),
                    );
              });
              if (zoomState.isCenterOnUserLocation) {
                _mapController.future.then(
                  (controller) {
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: zoomState.userLocation!.toLatLng(),
                          zoom: zoomState.zoomLevel,
                        ),
                      ),
                    );
                  },
                );
              } else {
                _mapController.future.then(
                  (controller) {
                    controller.animateCamera(
                      CameraUpdate.zoomTo(
                        zoomState.zoomLevel,
                      ),
                    );
                  },
                );
              }
            },
            builder: (context, zoomState) {
              return BlocBuilder<AllRestaurantsBloc, AllRestaurantsState>(
                builder: (context, allRestaurantsState) {
                  if (allRestaurantsState is AllRestaurantsSuccess) {
                    restaurants = allRestaurantsState.restaurants;
                  }
                  return BlocConsumer<MapMarkersBloc, MapMarkersState>(
                    listener: (context, state) {
                      if (state is MapMarkersLoaded) {
                        restaurantsMarkers = state.mapMarkers.restaurantMarker;
                        userMarker = state.mapMarkers.userMarker;
                      }
                    },
                    builder: (context, state) => GoogleMap(
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: const MinMaxZoomPreference(5, 25),
                      cameraTargetBounds: CameraTargetBounds(
                        LatLngBounds(
                          southwest: const LatLng(-2.85, 28.86), // Rwanda SW
                          northeast: const LatLng(14.9, 47.9), // Ethiopia NE
                        ),
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("userLocation"),
                          position: LatLng(
                            userLocationState.location.latitude,
                            userLocationState.location.longitude,
                          ),
                          icon: userMarker,
                        ),
                        if (restaurants != null && restaurants!.isNotEmpty)
                          ...(restaurants!)
                              .where((restaurant) =>
                                  restaurant.restaurantLocations!.isNotEmpty &&
                                  restaurant.restaurantLocations![0].latitude !=
                                      null &&
                                  restaurant
                                          .restaurantLocations![0].longitude !=
                                      null)
                              .map(
                                (restaurant) => Marker(
                                  markerId: MarkerId(restaurant.id!),
                                  zIndex: 2,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          RestaurantInfoBottomSheet(
                                        restaurant: restaurant,
                                      ),
                                    );
                                  },
                                  position: LatLng(
                                    restaurant
                                        .restaurantLocations![0].latitude!,
                                    restaurant
                                        .restaurantLocations![0].longitude!,
                                  ),
                                  icon: restaurantsMarkers,
                                ),
                              ),
                      },
                      mapType: MapType.normal,
                      buildingsEnabled: false,
                      trafficEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: userLocationState.location.toLatLng(),
                        zoom: zoomState.zoomLevel,
                      ),
                      onCameraMove: (cameraPosition) {
                        if (cameraPosition.zoom != zoomState.zoomLevel) {
                          // EasyDebounce.debounce(
                          //   'map-event-debouncer',
                          //   const Duration(
                          //     milliseconds: 200,
                          //   ),
                          //   () => context
                          //       .read<MapZoomBloc>()
                          //       .changeZoom(zoomLevel: cameraPosition.zoom),
                          // );
                        }
                      },
                      onCameraMoveStarted: () {
                        context
                            .read<DisplayRestaurantCountAndWalkingDistance>()
                            .hideComponent();
                      },
                      onCameraIdle: () {
                        context
                            .read<DisplayRestaurantCountAndWalkingDistance>()
                            .showComponent();
                      },
                      onMapCreated: (GoogleMapController controller) {
                        if (!_mapController.isCompleted) {
                          _mapController.complete(controller);
                        }
                        // controller.setMapStyle(mapStyle);
                      },
                      style: mapStyle,
                      onTap: (latLng) {
                        bool isTimeSelectorDialogueOpen =
                            BlocProvider.of<ShowWalkingDistanceTileBloc>(
                                    context)
                                .state;
                        //* if dialogue is Showing hide it
                        if (isTimeSelectorDialogueOpen) {
                          context
                              .read<ShowWalkingDistanceTileBloc>()
                              .hideDialogue();
                          return;
                        }

                        //* Move the camera to user location
                        context.read<MapZoomBloc>().centerUserLocation(
                              location: Location(
                                latitude: latLng.latitude,
                                longitude: latLng.longitude,
                              ),
                            );
                        context.read<UserLocationBloc>().add(ChangeUserLocation(
                              newLocation: Location.fromLatLgt(latLng),
                            ));

                        //* Update the filter used to fetch the results
                        context.read<DiscoveryStepsBloc>().add(
                              DiscoveryFilterUpdate(
                                latitude: latLng.latitude,
                                longitude: latLng.longitude,
                              ),
                            );

                        //* Get Restaurant Based on the selected Location
                        context.read<AllRestaurantsBloc>().add(
                              GetAllRestaurants(
                                latitude: latLng.latitude,
                                longitude: latLng.longitude,
                                radius:
                                    ((DistanceCalculator().zoomLevelToDistance(
                                              zoomLevel: zoomState.zoomLevel,
                                            ) /
                                            4196645.933333333) /
                                        2),
                              ),
                            );
                      },
                    ),
                  );
                },
              );
            },
          );
        } else {
          return FailureStateWidget(
              title: "Location Error",
              message: "Unable to load user location",
              imagePath: "assets/images/no_location_service.svg",
              buttonOnPress: () {
                context.read<UserLocationBloc>().add(const GetUserLocation());
              });
        }
      },
    );
  }
}

class SearchQueryCubit extends Cubit<String> {
  SearchQueryCubit() : super("Search for a place");

  void updateQuery(String query) {
    emit(query);
  }
}

class MapStateCubit extends Cubit<bool> {
  MapStateCubit() : super(false);

  void changeLoadingState(value) => emit(value);
}

class MarkersState extends Cubit<bool> {
  MarkersState() : super(false);
  void changeMarkersLoadingState(value) => emit(value);
}
