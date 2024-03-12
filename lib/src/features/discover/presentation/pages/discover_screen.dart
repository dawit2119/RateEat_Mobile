import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/external_app_intent.dart';
import '../../../features.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => listenShareMediaFiles(context));
    //* Check If User Location is Already Loaded
    var userLocation = context.read<UserLocationBloc>().state;
    if (userLocation is! UserLocationLoaded) {
      context.read<UserLocationBloc>().add(
            const GetUserLocation(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserLocationBloc, UserLocationState>(
      listener: (context, userLocationState) async {
        if (userLocationState is UserLocationError) {}
      },
      builder: (context, userLocationState) => Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: 100.h,
          width: 100.w,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalPadding(height: 12.sp),
                  Padding(
                    padding: EdgeInsets.only(left: 14.sp, right: 20.sp),
                    child: Text(
                      AppLocalizations.of(context)!.discoverPageText,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.left,
                      style: titleTextStyle.copyWith(
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                  verticalPadding(height: 8.sp),
                  DiscoverCard(
                    title: AppLocalizations.of(context)!.flow1Text,
                    subtitle: AppLocalizations.of(context)!.flow1Description,
                    svgUrl: "assets/images/restaurant_search.svg",
                    onTap: () {
                      if (userLocationState is UserLocationLoaded) {
                        //* Make Restaurant  List Empty
                        context.read<SelectFoodCategoryBloc>().add(
                              ResetCategoryEvent(),
                            );
                        context
                            .read<DiscoveryStepsBloc>()
                            .add(const StartDiscoverFlowEvent());

                        //*Get The Restaurants
                        context
                            .read<AllRestaurantsBloc>()
                            .add(ResetAllRestaurantsEvent());
                        context.pushNamed(
                          AppRoutes.locationOnMap,
                        );
                      } else {
                        showCustomToast(
                          context: context,
                          toastMessage:
                              AppLocalizations.of(context)!.getLocationText,
                          toastType: ToastType.info,
                        );

                        context
                            .read<UserLocationBloc>()
                            .add(const GetUserLocation());
                      }
                    },
                  ),
                  verticalPadding(height: 6.sp),
                  DiscoverCard(
                    title: AppLocalizations.of(context)!.flow2Text,
                    subtitle: AppLocalizations.of(context)!.flow2Description,
                    svgUrl: "assets/images/explore_menu.svg",
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.searchRestaurantPage,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
