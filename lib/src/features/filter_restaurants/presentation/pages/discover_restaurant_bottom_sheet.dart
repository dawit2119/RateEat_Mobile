import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import '../../../discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_bloc.dart';
import '../../../discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_event.dart';

class DiscoverRestaurantFilterBottomSheet extends StatefulWidget {
  const DiscoverRestaurantFilterBottomSheet({super.key});

  @override
  State<DiscoverRestaurantFilterBottomSheet> createState() =>
      _DiscoverRestaurantFilterBottomSheetState();
}

class _DiscoverRestaurantFilterBottomSheetState
    extends State<DiscoverRestaurantFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            verticalPadding(height: 1),
            Container(
              height: 3,
              width: 36,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                AppLocalizations.of(context)!.maxPriceText,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const GroupedPriceChips(
              prices: [50, 100, 200, 500, 1000, 2000, 5000],
              currencyCode: "",
            ),
            const Divider(color: AppColors.grey200),
            verticalPadding(height: 2),
            Text(
              AppLocalizations.of(context)!.ratingText,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            //Star Ratings section
            BlocBuilder<RatingBloc, double>(
              builder: (context, ratingState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: ratingState,
                      minRating: 0,
                      glowColor: AppColors.grey100,
                      glowRadius: 0.1,
                      itemSize: 35,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      unratedColor: AppColors.grey200,
                      updateOnDrag: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: AppColors.primaryColor,
                      ),
                      onRatingUpdate: (rating) {
                        context.read<RatingBloc>().changeRating(rating);
                        context
                            .read<DiscoveryStepsBloc>()
                            .add(DiscoveryFilterUpdate(minRating: rating));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                      child: (ratingState == 5)
                          ? Text(
                              "$ratingState ${AppLocalizations.of(context)!.starsText}",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey500,
                              ),
                            )
                          : Text(
                              "$ratingState ${AppLocalizations.of(context)!.starsAndUpText}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.grey500,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButtonColor,
                ),
                onPressed: () {
                  //* Update the page counter
                  context
                      .read<DiscoveryStepsBloc>()
                      .add(const DiscoveryFilterUpdate(page: 1));
                  //* Fetch new result
                  context.read<FetchDiscoverRestaurantResultBloc>().add(
                        FetchNewDiscoverRestaurantResultEvent(
                          discoveryStepsBloc:
                              context.read<DiscoveryStepsBloc>(),
                        ),
                      );
                  // context.pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.filterText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            verticalPadding(height: 1),
          ],
        ),
      ),
    );
  }
}

class RatingBloc extends Cubit<double> {
  RatingBloc() : super(1);
  changeRating(currentRating) => emit(currentRating);
}
