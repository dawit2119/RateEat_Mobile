import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/rating_and_reviews.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_popular_reviews/restaurant_popular_reviews_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/pages/widgets/opening_closing_time.dart';
import '../../../../review/presentation/widgets/suggest_price_change.dart';
import 'restaurant_direction_dialog.dart';
import 'restaurant_phone_number_row.dart';

class RestaurantTitle extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantTitle({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                restaurant.name ?? "",
                maxLines: 2,
                style: semiBold18.copyWith(
                  overflow: TextOverflow.ellipsis,
                  color: const Color(0xff24292e),
                  height: 1.2,
                ),
              )),
              BlocBuilder<RestaurantPopularReviewsBloc,
                  RestaurantPopularReviewsState>(
                builder: (context, state) {
                  if (state is PopularRestaurantReviewsLoaded) {
                    final reviews = state.popularReviews.reviews;
                    if (reviews.isNotEmpty) {
                      return RatingReviewWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.restaurantReviews,
                            pathParameters: {'restaurantId': restaurant.id!},
                            extra: {
                              'restaurant': restaurant,
                            },
                          );
                        },
                        rating: state.popularReviews.averageRating,
                        noOfReviews: state.popularReviews.numberOfReviews,
                      );
                    }
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
        SizedBox(
          width: 90.w,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: false,
                barrierLabel: 'Restaurant Info',
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child:
                              RestaurantDirectionDialog(restaurant: restaurant),
                        ),
                      ),
                    ),
                  );
                },
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Iconsax.location5,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    restaurant.restaurantLocations?[0].description ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                restaurant.isOpen ?? true
                    ? OpeningClosingTime(
                        restaurant: restaurant,
                      )
                    : Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                              size: 16
                                  .sp, // Slightly smaller for more inline feel
                            ),
                            SizedBox(width: 5), // tighter spacing
                            Text(
                              AppLocalizations.of(context)!
                                  .permanentlyClosedText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp, // Match with status tags
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
        if (restaurant.walkingTime.isNotEmpty &&
            restaurant.ridingTime.isNotEmpty)
          Row(
            children: [
              Icon(Icons.directions_walk_sharp, size: 17.sp),
              SizedBox(width: 8),
              Text(restaurant.walkingTime, style: TextStyle(fontSize: 15.sp)),
              SizedBox(width: 8),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey300,
                ),
              ),
              SizedBox(width: 8),
              Icon(Iconsax.driving, size: 17.sp),
              SizedBox(width: 8),
              Text(restaurant.ridingTime, style: TextStyle(fontSize: 15.sp)),
              SizedBox(width: 8),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey300,
                ),
              ),
              SizedBox(width: 8),
              Icon(Iconsax.routing_2, size: 17.sp, color: Colors.black87),
              SizedBox(width: 8),
              Text(
                "${restaurant.distance.length >= 6 ? restaurant.distance.substring(0, 5) : restaurant.distance} km",
                style: TextStyle(fontSize: 15.sp),
              ),
            ],
          ),
        // const SizedBox(
        //   height: 10,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Phone Numbers
            if (restaurant.restaurantPhoneNumbers != null &&
                restaurant.restaurantPhoneNumbers!.isNotEmpty)
              Expanded(
                child: RestaurantPhoneNumberRow(
                  phoneNumbers: restaurant.restaurantPhoneNumbers!,
                ),
              ),

            SizedBox(width: 8),

            // Menu Info Button
            IconButton(
              icon: Icon(
                Icons.info_outline,
                size: 22,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                showMenuInfoDialog(context, restaurant);
              },
              tooltip: 'Menu Info',
            ),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }

  // Future<void> _launchDirections({
  //   required Location destinationPoint,
  // }) async {
  //   final url =
  //       'https://www.google.com/maps/search/?api=1&query=${destinationPoint.latitude},${destinationPoint.longitude}';

  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  String formatPhoneNumber(String rawNumber) {
    rawNumber = rawNumber.trim();
    if (rawNumber.startsWith('+212')) {
      return rawNumber;
    }
    if (rawNumber.startsWith('251') && !rawNumber.startsWith('+')) {
      return '+$rawNumber';
    } else if (rawNumber.startsWith('0')) {
      return '+251${rawNumber.substring(1)}';
    } else if (rawNumber.startsWith('+251')) {
      return rawNumber;
    } else {
      return '+251$rawNumber';
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(
      Uri.parse(
        launchUri.toString(),
      ),
    );
  }
}
