import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_event.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/highest_rated/popular_event.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/change_location_action_buttons.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/widgets/google_map_content.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class ChangeUserLocationScreen extends StatefulWidget {
  const ChangeUserLocationScreen({super.key});

  @override
  State<ChangeUserLocationScreen> createState() => _ChangeUserLocationState();
}

class _ChangeUserLocationState extends State<ChangeUserLocationScreen>
    with TickerProviderStateMixin {
  DistanceCalculator distanceCalculator = DistanceCalculator();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    context.read<SearchQueryCubit>().updateQuery('Search for a place');
    var userLocationBloc = context.read<UserLocationBloc>();
    if (userLocationBloc.state is! UserLocationLoaded) {
      userLocationBloc.add(const GetUserLocation());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.changeLocationText,
          style: titleTextStyle,
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 10),
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textDark,
            size: 16,
          ),
        ),
      ),
      body: BlocConsumer<UserLocationBloc, UserLocationState>(
        listener: (context, userLocationState) {
          if (userLocationState is UserLocationLoaded) {
            _mapController.future.then(
              (controller) async {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: userLocationState.location.toLatLng(),
                      zoom: 18,
                    ),
                  ),
                );
              },
            );
          }
        },
        builder: (context, userLocationState) {
          if (userLocationState is UserLocationLoaded) {
            return SizedBox(
              height: 100.h,
              width: 100.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    onTap: (argument) {
                      context.read<UserLocationBloc>().add(
                            ChangeUserLocation(
                              newLocation: Location(
                                latitude: argument.latitude,
                                longitude: argument.longitude,
                              ),
                            ),
                          );
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('user_location'),
                        position: userLocationState.location.toLatLng(),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                      ),
                    },
                    compassEnabled: true,
                    mapType: MapType.normal,
                    buildingsEnabled: true,
                    zoomControlsEnabled: false,
                    minMaxZoomPreference: const MinMaxZoomPreference(15, 20),
                    cameraTargetBounds: CameraTargetBounds(
                      LatLngBounds(
                        southwest: const LatLng(-2.85, 28.86), // Rwanda SW
                        northeast: const LatLng(14.9, 47.9), // Ethiopia NE
                      ),
                    ),
                    initialCameraPosition: CameraPosition(
                      target: userLocationState.location.toLatLng(),
                      zoom: 18,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                      //? Define the map style(Color and layers)
                      // controller.setMapStyle(mapStyle);
                    },
                    style: mapStyle,
                  ),
                  //? search field area
                  Positioned(
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              context.pushNamed(AppRoutes.searchLocation);
                            },
                            child: Container(
                              height: 60,
                              width: 90.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [...elevation_2],
                                color: Colors.white,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Iconsax.search_normal_1,
                                    color: AppColors.grey500,
                                  ),
                                  horizontalPadding(width: 2),
                                  Expanded(
                                    child:
                                        BlocBuilder<SearchQueryCubit, String>(
                                      builder: (context, locationSearchState) {
                                        return Text(
                                          locationSearchState,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: AppColors.textColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          horizontalPadding(width: 1),
                        ],
                      ),
                    ),
                  ),
                  //? Action buttons
                  ChangeLocationActionButtons(
                    onChangeUserLocation: () {
                      _mapController.future.then(
                        (controller) async {
                          if (context.mounted) {
                            var userLocationBloc =
                                context.read<UserLocationBloc>();
                            double appBarHeight = AppBar().preferredSize.height;
                            double middleX = (100.w / 2) *
                                MediaQuery.of(context).devicePixelRatio;
                            double middleY = ((100.h - appBarHeight) / 2) *
                                MediaQuery.of(context).devicePixelRatio;
                            var updatedLocation = await controller.getLatLng(
                                ScreenCoordinate(
                                    x: middleX.toInt(), y: middleY.toInt()));
                            userLocationBloc.add(
                              ChangeUserLocation(
                                newLocation: Location(
                                  latitude: updatedLocation.latitude,
                                  longitude: updatedLocation.longitude,
                                ),
                              ),
                            );
                          }

                          // ignore: use_build_context_synchronously
                          // context.read<LocationDescriptionBloc>().add(
                          //       UpdateLocationDescription(
                          //         location: Location(
                          //           latitude: updatedLocation.latitude,
                          //           longitude: updatedLocation.longitude,
                          //         ),
                          //       ),
                          //     );
                        },
                      );
                      //* Fetch Popular and Recommended Items based on Changed Location
                      fetchPopularAndRecommendationItems();
                      Navigator.pop(context);
                    },
                    onNavigateToPinLocation: () {
                      _mapController.future.then(
                        (controller) async {
                          controller.moveCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: userLocationState.location.toLatLng(),
                                zoom: 18,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    onNavigateToUserLocation: () {
                      context
                          .read<UserLocationBloc>()
                          .add(const GetUserLocation());
                      _mapController.future.then(
                        (controller) async {
                          controller.moveCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: userLocationState.location.toLatLng(),
                                zoom: 18,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (userLocationState is UserLocationLoading) {
            return Center(
              child: Column(
                key: const Key('loading_map'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.dotsTriangle(
                    color: AppColors.primaryColor,
                    size: 60,
                  ),
                  Text(
                    AppLocalizations.of(context)!.loadingMapText,
                    style: subTitleTextStyle,
                  ),
                ],
              ),
            );
          } else if (userLocationState is UserLocationError) {
            return FailureStateWidget(
              title: AppLocalizations.of(context)!.loadingMapFailedText,
              message: userLocationState.message,
              imagePath: "",
              buttonOnPress: () {},
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController.future.then((value) => value.dispose());
    super.dispose();
  }

  void fetchPopularAndRecommendationItems() {
    var userLocation =
        (context.read<UserLocationBloc>().state as UserLocationLoaded).location;
    context.read<PopularBloc>().add(ResetTopRatedEvent());
    context.read<PopularBloc>().add(
          GetTopRatedEvent(
            page: 1,
            lat: userLocation.latitude,
            lng: userLocation.longitude,
            tags: context.read<TagBloc>().state.selectedTags,
          ),
        );
    context.read<HomePageNearbyRestaurantBloc>().add(
          GetNearByRestaurants(
            lat: userLocation.latitude,
            lng: userLocation.longitude,
            tags: context.read<TagBloc>().state.selectedTags,
            page: 1,
          ),
        );
  }
}
