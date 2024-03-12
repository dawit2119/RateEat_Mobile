import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../discover/presentation/bloc/bloc.dart';

class RestaurantCountWalkingDistance extends StatelessWidget {
  final String restaurantsCount;
  final int timeEstimate;
  final bool isWalking;

  const RestaurantCountWalkingDistance({
    super.key,
    required this.restaurantsCount,
    required this.timeEstimate,
    required this.isWalking,
  });

  @override
  Widget build(BuildContext context) {
    final discoverStepsState = context.read<DiscoveryStepsBloc>().state;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: elevation_4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          restaurantsCount == "-1"
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : Text(
                  "$restaurantsCount ${AppLocalizations.of(context)!.restText}",
                  style: const TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          verticalPadding(height: .05.h),
          Text(
            "${AppLocalizations.of(context)!.inText} ${discoverStepsState.discoverRestaurantProps.maxTravelTime} ${AppLocalizations.of(context)!.minutesText} ${isWalking ? AppLocalizations.of(context)!.walkingDistText : AppLocalizations.of(context)!.drivingDistText}",
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey600,
            ),
          ),
          verticalPadding(height: .05.h),
        ],
      ),
    );
  }
}
