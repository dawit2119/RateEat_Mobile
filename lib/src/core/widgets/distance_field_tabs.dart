import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../features/discover/discover.dart';
import '../../features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import '../../features/map_section/map_section.dart';
import '../core.dart';

enum TransportMode { walking, driving }

class TransportModeCubit extends Cubit<TransportMode> {
  TransportModeCubit()
      : super(
          TransportMode.walking,
        );
  void changeTransportMode(TransportMode transportMode) => emit(
        transportMode,
      );
}

class DistanceFieldTabs extends StatefulWidget {
  const DistanceFieldTabs({super.key});

  @override
  State<DistanceFieldTabs> createState() => _DistanceFieldTabsState();
}

class _DistanceFieldTabsState extends State<DistanceFieldTabs>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 35.h,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: elevation_4,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 1.3.h,
            ),
            Text(
              AppLocalizations.of(context)!.maxDistText,
              style: GoogleFonts.poppins(
                color: AppColors.textDark,
                fontSize: 2.2.h,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 1.3.h,
            ),
            Text(
              AppLocalizations.of(context)!.locationMaxDistText,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 1.9.h,
                color: AppColors.grey600,
              ),
            ),
            SizedBox(
              height: 1.3.h,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.grayLight,
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: TabBar(
                onTap: (index) {
                  if (index == 0) {
                    context.read<TransportModeCubit>().changeTransportMode(
                          TransportMode.walking,
                        );
                    context.read<DiscoveryStepsBloc>().add(
                          const DiscoveryFilterUpdate(
                            transportMode: TransportMode.walking,
                          ),
                        );
                  } else {
                    context.read<TransportModeCubit>().changeTransportMode(
                          TransportMode.driving,
                        );
                    context.read<DiscoveryStepsBloc>().add(
                          const DiscoveryFilterUpdate(
                            transportMode: TransportMode.driving,
                          ),
                        );
                  }
                  final discoveryStepsState =
                      context.read<DiscoveryStepsBloc>().state;
                  final transportModeState =
                      context.read<TransportModeCubit>().state;
                  final maxTravelTime =
                      discoveryStepsState.discoverRestaurantProps.maxTravelTime;
                  final isWalking = transportModeState == TransportMode.walking;

                  double radius = isWalking
                      ? DistanceCalculator().walkingDistance(
                          Duration(minutes: maxTravelTime),
                        )
                      : DistanceCalculator()
                          .drivingDistance(Duration(minutes: maxTravelTime));
                  double zoomLevel = DistanceCalculator().distanceToZoomLevel(
                    distanceInMeters: radius,
                  );

                  //* Get User Location
                  final location = (context.read<UserLocationBloc>().state
                          as UserLocationLoaded)
                      .location;
                  //* Get Restaurant Based on Location
                  context.read<AllRestaurantsBloc>().add(
                        GetAllRestaurants(
                          latitude: location.latitude,
                          longitude: location.longitude,
                          radius: ((DistanceCalculator().zoomLevelToDistance(
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
                controller: _tabController,
                indicatorPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  boxShadow: elevation_2,
                  borderRadius: BorderRadius.circular(10),
                ),
                physics: const BouncingScrollPhysics(
                    parent: FixedExtentScrollPhysics()),
                tabs: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      // horizontal: .4.h,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.walkingDistText,
                      style: TextStyle(
                        fontSize: 1.8.h,
                        color: AppColors.grey600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.2.h,
                      horizontal: .4.h,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.drivingDistText,
                      style: TextStyle(
                        fontSize: 1.8.h,
                        color: AppColors.grey600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.w),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  // Walking distance
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: GroupedChips(isWalking: true),
                  ),
                  // Driving distance
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: GroupedChips(isWalking: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
