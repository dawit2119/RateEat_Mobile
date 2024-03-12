import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../../data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';

class RestaurantInfoSection extends StatelessWidget {
  const RestaurantInfoSection({
    super.key,
    required this.restaurant,
  });

  final DiscoverRestaurantResultModel restaurant;

  @override
  Widget build(BuildContext context) {
    var transportMode = context.read<TransportModeCubit>().state;
    return BlocBuilder<UserLocationBloc, UserLocationState>(
      builder: (context, userLocationState) {
        if (userLocationState is UserLocationLoaded) {}
        return GestureDetector(
          onTap: () {
            context.pushNamed(
              AppRoutes.restaurantDetail,
              pathParameters: {'restaurantId': restaurant.id!},
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  child: (restaurant.restaurantImages != null &&
                          restaurant.restaurantImages!.isNotEmpty &&
                          (restaurant.restaurantImages![0].url ?? "")
                              .isNotEmpty)
                      ? CachedNetworkImage(
                          height: 9.h,
                          width: 9.h,
                          memCacheHeight: (9.h).cacheSize(context),
                          memCacheWidth: (9.h).cacheSize(context),
                          imageUrl: restaurant.restaurantImages![0].url!,
                          cacheKey: restaurant.id,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            height: 6.h,
                            width: 6.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primaryColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/rate_eat_logo.png',
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            height: 6.h,
                            width: 6.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.shimmerBaseColor,
                            ),
                            child: Shimmer.fromColors(
                              baseColor: AppColors.shimmerBaseColor,
                              highlightColor: AppColors.shimmerHighlightColor,
                              child: const SizedBox.expand(),
                            ),
                          ),
                        )
                      : Container(
                          height: 9.h,
                          width: 9.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/rate_eat_logo.png',
                              fit: BoxFit.contain,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
              horizontalPadding(width: 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name ?? "",
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalPadding(height: .5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            restaurant.restaurantTags?.length ?? 0, (index) {
                          return Row(
                            children: [
                              Text(
                                restaurant.restaurantTags?[index].name ?? "",
                                style: subTitleTextStyle,
                              ),
                              horizontalPadding(width: 0.5),
                              Container(
                                height: 4,
                                width: 4,
                                color: AppColors.grey300,
                              ),
                              horizontalPadding(width: 0.5),
                            ],
                          );
                        }),
                      ),
                    ),
                    verticalPadding(height: .5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/star_full_rounded.svg",
                          colorFilter: ColorFilter.mode(
                              AppColors.primaryColor, BlendMode.srcIn),
                          height: 16,
                          width: 16,
                        ),
                        horizontalPadding(width: .4),
                        Text(
                          restaurant.averageRating?.toStringAsFixed(1) ?? "0.0",
                          style: subTitleTextStyle,
                        ),
                        Text(
                          "(${restaurant.numberOfReviews})",
                          style: subTitleTextStyle.copyWith(
                            color: AppColors.grey300,
                          ),
                        ),
                      ],
                    ),
                    verticalPadding(height: .5),
                    transportMode == TransportMode.driving
                        ? Row(
                            children: [
                              const Icon(
                                Icons.directions_bus,
                                size: 14,
                              ),
                              const SizedBox(
                                width: 1,
                              ),
                              Text(
                                "${restaurant.ridingTime}",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const Icon(
                                Icons.directions_walk,
                                size: 14,
                              ),
                              const SizedBox(
                                width: 1,
                              ),
                              Text(
                                "${restaurant.walkingTime}",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
