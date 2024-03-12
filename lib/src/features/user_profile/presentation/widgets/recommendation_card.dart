import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'dart:math';

class RecommendationCard extends StatelessWidget {
  final UserRecommendation userRecommendation;

  const RecommendationCard({super.key, required this.userRecommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: IntrinsicHeight(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 7.h,
                          width: 7.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.grey200,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                userRecommendation.item != null
                                    ? userRecommendation.item!.imageUrl
                                    : userRecommendation.restaurant!.imageUrl,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.5.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userRecommendation.item != null
                                  ? userRecommendation.item!.name
                                  : userRecommendation.restaurant!.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17.sp),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.star_half_rounded,
                                  color: Colors.red,
                                  size: 3.h,
                                ),
                                SizedBox(
                                  width: 0.5.w,
                                ),
                                Text(
                                  userRecommendation.item != null
                                      ? userRecommendation.item!.review
                                          .toString()
                                      : userRecommendation.restaurant!.review
                                          .toString(),
                                  style: const TextStyle(
                                    color: AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    userRecommendation.item != null
                        ? Row(
                            children: [
                              Transform.rotate(
                                angle: pi / 4,
                                child: Icon(
                                  Icons.push_pin,
                                  size: 3.h,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                userRecommendation.item!.restaurantName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.sp,
                                ),
                              )
                            ],
                          )
                        : const SizedBox(
                            width: 0,
                          )
                  ],
                ),
                IconButton(
                  onPressed: () {
                    if (userRecommendation.item != null) {
                      context.pushNamed(
                        AppRoutes.itemDetail,
                        pathParameters: {
                          'itemId': userRecommendation.item!.id,
                        },
                      );
                    } else {
                      context.pushNamed(
                        AppRoutes.restaurantDetail,
                        pathParameters: {
                          'restaurantId': userRecommendation.restaurant!.id,
                        },
                      );
                    }
                  },
                  icon: Icon(
                    Iconsax.export_3,
                    color: AppColors.grey600,
                    size: 3.h,
                  ),
                ),
              ],
            ),
            Text(
              userRecommendation.recommendationContent != ""
                  ? userRecommendation.recommendationContent ?? "no content"
                  : "no content",
              maxLines: 2,
              style: TextStyle(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w200,
                  fontSize: 16.sp),
            ),
            const Divider(
              thickness: 0.5,
              color: AppColors.grey200,
            ),
          ],
        ),
      ),
    );
  }
}
