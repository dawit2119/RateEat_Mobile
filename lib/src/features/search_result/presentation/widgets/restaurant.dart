import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rateeat_mobile/src/core/utils/is_restaurant_open.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/pages/widgets/opening_closing_time.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../restaurant_detail/presentation/pages/widgets/opening_closing_time.dart';
import '../../../features.dart';

class RestaurantCard extends StatelessWidget {
  final Location restaurantLocation;
  final Restaurant restaurant;
  final Function()? onPressed;

  const RestaurantCard({
    super.key,
    this.onPressed,
    required this.restaurant,
    required this.restaurantLocation,
  });

  bool isFeasibleWalkingTime() {
    var parsedTime = restaurant.walkingTime.split(" ");
    var time = parsedTime[0];
    var measurement = parsedTime[1];
    var parsedWalkingTime = double.parse(time);
    return parsedWalkingTime <= 40 && measurement == "min";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (context.read<UserLocationBloc>().state is! UserLocationLoaded) {
      context.read<UserLocationBloc>().add(const GetUserLocation());
    }

    final restaurantImages = restaurant.restaurantImages;
    final String leadingImage = restaurantImages != null &&
            restaurantImages.isNotEmpty
        ? restaurantImages[0].url
        : "https://img.freepik.com/free-vector/building-restaurant-flat-design_23-2147537664.jpg?t=st=1728580902~exp=1728584502~hmac=fdc29463afbaf88d53dfc2b70c229723434dd683b124324fe2fd598546a5999a&w=740";

    final double distanceKm = double.tryParse(restaurant.distance) ?? 0;
    final String distanceText = distanceKm < 1
        ? "${(distanceKm * 1000).toStringAsFixed(0)} ${AppLocalizations.of(context)!.meterText}"
        : "${distanceKm.toStringAsFixed(1)} ${AppLocalizations.of(context)!.kiloMeterText}";

    final bool walkOk = isFeasibleWalkingTime();
    final IconData travelIcon =
        walkOk ? Icons.directions_walk : Icons.directions_bus;
    final String travelText =
        walkOk ? restaurant.walkingTime : restaurant.ridingTime;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Color(0x146a737d), offset: Offset(0, 2), blurRadius: 8),
            BoxShadow(
                color: Color(0x146a737d), offset: Offset(0, 0), blurRadius: 10),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed ??
                () {
                  context.pushNamed(
                    AppRoutes.restaurantDetail,
                    pathParameters: {'restaurantId': restaurant.id!},
                  );
                },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image (left)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: leadingImage ??
                          "https://img.freepik.com/free-vector/building-restaurant-flat-design_23-2147537664.jpg?t=st=1728580902~exp=1728584502~hmac=fdc29463afbaf88d53dfc2b70c229723434dd683b124324fe2fd598546a5999a&w=740",
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 92,
                        height: 92,
                        color: const Color(0xFFF2F2F2),
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 92,
                        height: 92,
                        color: const Color(0xFFF2F2F2),
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content (right)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + Open/Closed
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              // Right pinned status (always top-right / first line)
                              Align(
                                alignment: Alignment.topRight,
                                child: (restaurant.isOpen ?? true)
                                    ? OpeningClosingTime(restaurant: restaurant)
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.red,
                                            size: 16.sp,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .permanentlyClosedText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: medium14.copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),

                              // Left title with space reserved for the right widget
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                  end:
                                      120, // tune: reserved width for the right tag
                                ),
                                child: Text(
                                  restaurant.name ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: semiBold16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Address (no fixed width -> avoids overflow)
                        Row(
                          children: [
                            Icon(
                              Iconsax.location5,
                              color: AppColors.primaryColor,
                              size: 15.sp,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                restaurant.restaurantLocations?.isNotEmpty ==
                                        true
                                    ? (restaurant.restaurantLocations![0]
                                            .description ??
                                        "")
                                    : "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: regular14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Rating + reviews
                        Row(
                          children: [
                            Icon(Icons.star_rounded,
                                color: AppColors.primaryColor, size: 1.7.h),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "${restaurant.averageRating} • (${restaurant.numberOfReviews} ${AppLocalizations.of(context)!.reviewsText})",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    medium14.copyWith(color: AppColors.grey600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Bottom row: distance/time pill aligned right
                        Row(
                          children: [
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    distanceText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 1.3.h,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(travelIcon,
                                      size: 1.4.h, color: Colors.white),
                                  const SizedBox(width: 3),
                                  Text(
                                    travelText,
                                    style: GoogleFonts.poppins(
                                      fontSize: 1.3.h,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                          // (restaurant.isOpen!)
                          //     ? Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 10),
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //               border: Border.all(
                          //                   color: (isRestaurantOpen(
                          //                           openingHour:
                          //                               restaurant.openingHour,
                          //                           closingHour:
                          //                               restaurant.closingHour))
                          //                       ? Colors.green
                          //                       : Colors.red),
                          //               borderRadius:
                          //                   BorderRadius.circular(10)),
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(5.0),
                          //             child: isRestaurantOpen(
                          //                     openingHour:
                          //                         restaurant.openingHour,
                          //                     closingHour:
                          //                         restaurant.closingHour)
                          //                 ? Container(
                          //                     alignment: Alignment.center,
                          //                     child: Text(
                          //                       AppLocalizations.of(context)!
                          //                           .openText,
                          //                       style: GoogleFonts.poppins(
                          //                         fontSize: 14.sp,
                          //                         fontWeight: FontWeight.bold,
                          //                         color: Colors.green,
                          //                       ),
                          //                     ),
                          //                   )
                          //                 : Container(
                          //                     alignment: Alignment.center,
                          //                     child: Text(
                          //                       AppLocalizations.of(context)!
                          //                           .closedText,
                          //                       style: GoogleFonts.poppins(
                          //                         fontSize: 14.sp,
                          //                         fontWeight: FontWeight.bold,
                          //                         color: Colors.red,
                          //                       ),
                          //                     ),
                          //                   ),
                          //           ),
                          //         ),
                          //       )
                          //     : Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 10,
                          //         ),
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //               border: Border.all(color: Colors.red),
                          //               borderRadius:
                          //                   BorderRadius.circular(10)),
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(5.0),
                          //             child: Text(
                          //               AppLocalizations.of(context)!
                          //                   .permanentlyClosedText,
                          //               style: GoogleFonts.poppins(
                          //                 fontSize: 14.sp,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Colors.red,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       )