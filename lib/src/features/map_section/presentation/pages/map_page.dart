import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/widgets/three_dots_fading_animation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../../features.dart';
import '../widgets/google_map_content.dart';

class LocationOnMap extends StatefulWidget {
  const LocationOnMap({super.key});

  @override
  State<LocationOnMap> createState() => _LocationOnMapState();
}

class _LocationOnMapState extends State<LocationOnMap> {
  late Location userLocation;
  DistanceCalculator distanceCalculator = DistanceCalculator();

  @override
  void initState() {
    super.initState();
    context.read<NetworkBloc>().add(NetworkObserve());
    context.read<TransportModeCubit>().changeTransportMode(
          TransportMode.walking,
        );
    var userLocationState =
        context.read<UserLocationBloc>().state as UserLocationLoaded;
    userLocation = userLocationState.location;

    final zoomLevel = context.read<MapZoomBloc>().state.zoomLevel;
    //* Get Restaurant Based on Location
    context.read<AllRestaurantsBloc>().add(GetAllRestaurants(
          latitude: userLocation.latitude,
          longitude: userLocation.longitude,
          radius: ((distanceCalculator.zoomLevelToDistance(
                    zoomLevel: zoomLevel,
                  )) /
                  4196645.933333333) /
              2,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShowWalkingDistanceTileBloc(),
      child: BlocBuilder<ShowWalkingDistanceTileBloc, bool>(
        builder: (context, walkingDialogueState) {
          return SafeArea(
            child: Scaffold(
              body: BlocConsumer<NetworkBloc, NetworkState>(
                listener: (context, networkState) {
                  if (networkState is NetworkFailed) {
                    showCustomToast(
                      context: context,
                      toastMessage: AppLocalizations.of(context)!.networkText,
                      toastType: ToastType.warning,
                    );
                  }
                  if (networkState is NetworkSuccess) {
                    context.read<AllRestaurantsBloc>().add(
                          GetAllRestaurants(
                            latitude: userLocation.latitude,
                            longitude: userLocation.longitude,
                            radius: ((distanceCalculator.zoomLevelToDistance(
                                      zoomLevel: context
                                          .read<MapZoomBloc>()
                                          .state
                                          .zoomLevel,
                                    )) /
                                    4196645.933333333) /
                                2,
                          ),
                        );
                  }
                },
                // builder
                builder: (context, networkState) {
                  if (networkState is NetworkFailed) {
                    return FailureStateWidget(
                      title: AppLocalizations.of(context)!.noInternetText,
                      message: AppLocalizations.of(context)!.connText,
                      imagePath: "assets/icons/no_internet.svg",
                      buttonOnPress: () {
                        context.read<NetworkBloc>().add(NetworkObserve());
                      },
                    );
                  }
                  if (networkState is NetworkSuccess) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        const GoogleMapContent(),
                        const LocationSearchField(),
                        Positioned(
                          bottom: 36.sp,
                          right: 16.sp,
                          child: Container(
                            height: 30.sp,
                            width: 30.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.sp),
                              boxShadow: [...elevation_2],
                            ),
                            child: InkWell(
                              splashColor: Colors.green,
                              onTap: () {
                                context.read<UserLocationBloc>().add(
                                      ChangeUserLocation(
                                        newLocation: userLocation,
                                      ),
                                    );
                                context.read<MapZoomBloc>().centerUserLocation(
                                      location: userLocation,
                                    );
                                context.read<AllRestaurantsBloc>().add(
                                      GetAllRestaurants(
                                        latitude: userLocation.latitude,
                                        longitude: userLocation.longitude,
                                        radius: ((distanceCalculator
                                                    .zoomLevelToDistance(
                                                  zoomLevel: context
                                                      .read<MapZoomBloc>()
                                                      .state
                                                      .zoomLevel,
                                                )) /
                                                4196645.933333333) /
                                            2,
                                      ),
                                    );
                              },
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/discover.svg",
                                  colorFilter: ColorFilter.mode(
                                      AppColors.grey600, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const BottomActionButtons(),
                        BlocBuilder<DisplayRestaurantCountAndWalkingDistance,
                            bool>(
                          builder: (context, showComponent) {
                            return Positioned(
                              top: 120,
                              child: TweenAnimationBuilder(
                                builder: (context, opacity, child) {
                                  return Opacity(
                                    opacity: opacity,
                                    child: child,
                                  );
                                },
                                tween: showComponent
                                    ? Tween<double>(begin: 0, end: 1)
                                    : Tween<double>(begin: 1, end: 0),
                                duration: const Duration(milliseconds: 200),
                                child: BlocBuilder<MapZoomBloc, MapZoomState>(
                                  builder: (context, zoomState) {
                                    return BlocBuilder<AllRestaurantsBloc,
                                        AllRestaurantsState>(
                                      builder: (context, state) {
                                        final timeEstimate =
                                            (zoomState.isWalking)
                                                ? distanceCalculator
                                                        .zoomLevelToWalkingTime(
                                                      zoomLevel:
                                                          zoomState.zoomLevel,
                                                    ) ~/
                                                    4196645.933333333
                                                : distanceCalculator
                                                        .zoomLevelToDrivingTime(
                                                      zoomLevel:
                                                          zoomState.zoomLevel,
                                                    ) ~/
                                                    4196645.933333333;

                                        if (state is AllRestaurantsSuccess) {
                                          return RestaurantCountWalkingDistance(
                                            isWalking: zoomState.isWalking,
                                            timeEstimate: timeEstimate,
                                            restaurantsCount: state
                                                .restaurants.length
                                                .toString(),
                                          );
                                        } else if (state
                                            is AllRestaurantsLoading) {
                                          return const LoadingDots();
                                        }

                                        return RestaurantCountWalkingDistance(
                                          isWalking: zoomState.isWalking,
                                          timeEstimate: timeEstimate,
                                          restaurantsCount: "--",
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: Column(
                      key: const Key('loading_map'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.dotsTriangle(
                          color: AppColors.primaryColor,
                          size: 60,
                        ),
                        verticalPadding(height: 2),
                        Text(
                          AppLocalizations.of(context)!.loadingMapText,
                          style: titleTextStyle,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class LocationSearchField extends StatelessWidget {
  const LocationSearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 3.5.h,
      child: BlocBuilder<UserLocationBloc, UserLocationState>(
        builder: (context, locationState) {
          return InkWell(
            onTap: () {
              context.pushNamed(AppRoutes.searchLocation);
            },
            child: Container(
              height: 8.h,
              width: 94.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [...elevation_8],
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/search.svg",
                    colorFilter:
                        ColorFilter.mode(AppColors.grey600, BlendMode.srcIn),
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.searchLocationText,
                        style: titleTextStyle.copyWith(fontSize: 2.h),
                      ),
                      BlocBuilder<SearchQueryCubit, String>(
                        builder: (context, state) {
                          return SizedBox(
                            width: 60.w,
                            child: Text(
                              state,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: subTitleTextStyle.copyWith(
                                fontSize: 1.5.h,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShowWalkingDistanceTileBloc extends Cubit<bool> {
  ShowWalkingDistanceTileBloc() : super(false);
  void hideDialogue() => emit(false);
  void flipState() => emit(!state);
}

class DisplayRestaurantCountAndWalkingDistance extends Cubit<bool> {
  DisplayRestaurantCountAndWalkingDistance() : super(true);

  void hideComponent() => emit(false);
  void showComponent() => emit(true);
}
