import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomActionButtons extends StatelessWidget {
  const BottomActionButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: 100.w,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          // color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<ShowWalkingDistanceTileBloc, bool>(
                builder: (context, userLocationState) {
                  if (userLocationState) {
                    return const DistanceFieldTabs();
                  }
                  return Container();
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        //* Add Search Radius
                        context.read<DiscoveryStepsBloc>().add(
                              DiscoveryFilterUpdate(
                                distanceToTravel:
                                    ((DistanceCalculator().zoomLevelToDistance(
                                              zoomLevel: context
                                                  .read<MapZoomBloc>()
                                                  .state
                                                  .zoomLevel,
                                            ) /
                                            4196645.933333333) /
                                        2),
                              ),
                            );
                        context.pushNamed(AppRoutes.selectFoodCategory);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 30.sp),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.continueText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  horizontalPadding(width: 1),
                  Container(
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
                        BlocProvider.of<ShowWalkingDistanceTileBloc>(context)
                            .flipState();
                      },
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/timer.svg",
                          colorFilter: const ColorFilter.mode(
                            AppColors.grey700,
                            BlendMode.srcIn,
                          ),
                          height: 22,
                          width: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
