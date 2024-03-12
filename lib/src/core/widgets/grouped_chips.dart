import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import '../../features/discover/presentation/bloc/discoverySteps/discover_restaurants_state.dart';
import '../../features/features.dart';
import '../core.dart';

class GroupedChips extends StatelessWidget {
  final bool isWalking;
  const GroupedChips({
    super.key,
    required this.isWalking,
  });
  bool checkTransportMode(
    TransportMode transportMode,
  ) {
    if (isWalking) {
      if (transportMode == TransportMode.walking) return true;
      return false;
    }
    if (transportMode == TransportMode.driving) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var transportModeState = context.read<TransportModeCubit>().state;
    return BlocProvider(
      create: (BuildContext context) => MultiChipsBlock(),
      child: BlocBuilder<MultiChipsBlock, int>(
        builder: (BuildContext blocContext, int selectedChip) {
          return BlocBuilder<DiscoveryStepsBloc, DiscoverRestaurantState>(
            builder: (context, discoverState) {
              return Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: List.generate(6, (index) {
                    var time = (index + 1) * 5;

                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.sp, horizontal: 8.sp),
                      child: SingleChip(
                        selected: index == selectedChip ||
                            (checkTransportMode(transportModeState) &&
                                discoverState.discoverRestaurantProps
                                        .maxTravelTime ==
                                    time),
                        title: '${(index + 1) * 5} mins',
                        onTap: () {
                          blocContext
                              .read<MultiChipsBlock>()
                              .changeState(index);
                          context.read<DiscoveryStepsBloc>().add(
                                DiscoveryFilterUpdate(
                                  maxTravelTime: time,
                                ),
                              );
                          double distance = isWalking
                              ? DistanceCalculator()
                                  .walkingDistance(Duration(minutes: time))
                              : DistanceCalculator()
                                  .drivingDistance(Duration(minutes: time));
                          double zoomLevel = DistanceCalculator()
                              .distanceToZoomLevel(distanceInMeters: distance);

                          //* Get User Location
                          final location = (context
                                  .read<UserLocationBloc>()
                                  .state as UserLocationLoaded)
                              .location;
                          //* Get Restaurant Based on Location
                          context.read<AllRestaurantsBloc>().add(
                                GetAllRestaurants(
                                  latitude: location.latitude,
                                  longitude: location.longitude,
                                  radius: ((DistanceCalculator()
                                              .zoomLevelToDistance(
                                            zoomLevel: zoomLevel,
                                          ) /
                                          4196645.933333333) /
                                      2),
                                ),
                              );

                          //* Get Zoom Level for the map
                          context.read<MapZoomBloc>().changeZoom(
                                zoomLevel: zoomLevel,
                                isWalking: isWalking,
                              );
                        },
                      ),
                    );
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SingleChip extends StatelessWidget {
  const SingleChip({
    super.key,
    required this.selected,
    required this.title,
    required this.onTap,
  });
  final bool selected;
  final String title;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.sp),
          color: selected ? AppColors.primaryColor : AppColors.grey100,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: selected ? Colors.white : AppColors.grey500,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class MultiChipsBlock extends Cubit<int> {
  MultiChipsBlock() : super(-1);
  void changeState(value) => emit(value);
}
