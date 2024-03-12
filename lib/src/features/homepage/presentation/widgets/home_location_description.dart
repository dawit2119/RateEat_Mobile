import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../location_search/presentation/bloc/location_description/location_description_bloc.dart';

class HomeLocationDescription extends StatelessWidget {
  const HomeLocationDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //* Location Description
        BlocConsumer<UserLocationBloc, UserLocationState>(
            listener: (context, state) {
          if (state is UserLocationLoaded) {
            context.read<LocationDescriptionBloc>().add(
                  UpdateLocationDescription(
                    location: Location(
                      latitude: state.location.latitude,
                      longitude: state.location.longitude,
                    ),
                  ),
                );
          }
          if (state is UserLocationError) {
            showCustomToast(
              context: context,
              toastMessage:
                  AppLocalizations.of(context)!.pleaseAllowLocationText,
              toastType: ToastType.error,
            );
          }
        }, builder: (context, locationState) {
          if (locationState is UserLocationLoading) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Iconsax.location5,
                    color: AppColors.primaryColor,
                    size: 26,
                  ),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.gettingLocationText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: subTitleTextStyle.copyWith(
                        color: AppColors.textDark,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (locationState is UserLocationError) {
            return GestureDetector(
              onTap: () {
                context.read<UserLocationBloc>().add(
                      const GetUserLocation(),
                    );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.location_cross5,
                    color: Colors.orange,
                    size: 20.sp,
                  ),
                  SizedBox(width: 1.w),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!
                          .turnOnLocationForRecommendationText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: subTitleTextStyle.copyWith(
                        color: AppColors.grey600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    Iconsax.arrow_down5,
                    color: AppColors.grey400,
                    size: 17.sp,
                  ),
                ],
              ),
            );
          }
          return BlocBuilder<LocationDescriptionBloc, LocationDescriptionState>(
            builder: (context, state) {
              var address = state.locationDescription;
              final addressIsEmpty = address == "";
              return GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoutes.changeUserLocation,
                    extra: 3,
                  );
                },
                child: (!addressIsEmpty)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.location5,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 1.w),
                          Flexible(
                            child: Text(
                              address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: subTitleTextStyle.copyWith(
                                color: AppColors.textDark,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Icon(
                            Iconsax.arrow_down5,
                            color: AppColors.grey400,
                            size: 17.sp,
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.location5,
                            color: Colors.orange,
                            size: 20.sp,
                          ),
                          SizedBox(width: 1.w),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .locationDescriptionNotFoundText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: subTitleTextStyle.copyWith(
                                color: AppColors.textDark,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Icon(
                            Iconsax.arrow_down5,
                            color: AppColors.grey400,
                            size: 17.sp,
                          ),
                        ],
                      ),
              );
            },
          );
        })
      ],
    );
  }
}
